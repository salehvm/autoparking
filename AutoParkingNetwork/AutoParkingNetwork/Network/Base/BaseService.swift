//
//  BaseService.swift
//  AutoParkingNetwork
//
//  Created by Saleh Majidov on 24/06/2024.
//

import Foundation
import Moya

public enum ServiceError: Swift.Error {
    case networkError
    case unauthorizedError
    case serializationError(internal: Swift.Error)
    case nonJSONResponse(String)
}

public protocol BaseServiceProtocol {
    var delegate: BaseServiceDelegate? { get set }
    var dataSource: BaseServiceDataSource? { get set }
    func cancelAll()
}

public protocol BaseServiceDelegate: AnyObject {
    func unauthorizedError()
}

public protocol BaseServiceDataSource: AnyObject {
    func getAccessToken() -> String?
    func checkFailure(_ isNoInternet: Bool, completion: @escaping (Bool) -> Void)
}

public class BaseService: BaseServiceProtocol {
    
    public weak var delegate: BaseServiceDelegate?
    public weak var dataSource: BaseServiceDataSource?
    private var requests: [Cancellable] = []
    internal var authPlugin: AuthPlugin!
    
    init() {
        let tokenClosure: () -> String = { [weak self] in
            return self?.dataSource?.getAccessToken() ?? ""
        }
        self.authPlugin = AuthPlugin(tokenClosure: tokenClosure)
    }
    
    // MARK: - Internal
    
    internal func request<API, SuccessM, WrongM>(
        _ provider: MoyaProvider<API>,
        target: API,
        successCode: Int = 200,
        checkFailure: Bool = true,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
        completion: @escaping (_ result: Result<SuccessM, WrongM>) -> ()
    ) where API: TargetType, SuccessM: Decodable, WrongM: Decodable {
        
        let request = provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    if response.statusCode == successCode {
                        if let jsonString = String(data: response.data, encoding: .utf8) {
                            print("Raw JSON Response: \(jsonString)")
                        }
                        
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = keyDecodingStrategy
                        let result = try decoder.decode(SuccessM.self, from: response.data)
                        
                        print("Decoded Object: \(result)")
                        
                        completion(.success(result))
                        
                    } else {
                        let result = try response.map(WrongM.self)
                        completion(.wrong(result))
                    }
                } catch {
                    print("Serialization error: \(error)")
                    completion(.failure(ServiceError.serializationError(internal: error)))
                }
                
            case let .failure(error):
                completion(.failure(ServiceError.networkError))
            }
        }
        requests.append(request)
    }
    
    // MARK: - Public
    
    public func cancelAll() {
        requests.forEach { cancellable in cancellable.cancel() }
        requests.removeAll()
    }
}
