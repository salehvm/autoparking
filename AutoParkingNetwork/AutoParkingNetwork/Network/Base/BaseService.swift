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
    
    internal func request<API, SuccessM, WrongM>(_ provider: MoyaProvider<API>, target: API, successCode: Int, checkFailure: Bool, completion: @escaping (_ result: Result<SuccessM, WrongM>) -> ()) where SuccessM: Decodable, WrongM: Decodable {
        
        
        
        let request = provider.request(target) { (result) in
            
            switch result {
                
            case let .success(response):
                do {
                    if response.statusCode == successCode {
                        
                        
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let result = try decoder.decode(SuccessM.self, from: response.data)
                        completion(.success(result))
                        
                    }
                    
                    else {
                        let result = try response.map(WrongM.self)
                        completion(.wrong(result))
                    }
                }
                catch {
                    print("log: ", error)
                    //                    self.failure(false, provider, target, successCode, checkFailure, completion)
                    completion(.failure(Service.Error.serializationError(internal: error)))
                }
                
            case let .failure(error):
                switch error {
                case let .underlying(error2, _):
                    let cancelledError = error2.asAFError?.isExplicitlyCancelledError ?? false
                    if !cancelledError {
                        //                        self.failure(false, provider, target, successCode, checkFailure, completion)
                        completion(.failure(error))
                    }
                default:
                    
                    //                    self.failure(false, provider, target, successCode, checkFailure, completion)
                    completion(.failure(error))
                }
            }
        }
        requests.append(request)
    }
    
    internal func request<API, SuccessM, WrongM>(_ provider: MoyaProvider<API>, target: API, completion: @escaping (_ result: Result<SuccessM, WrongM>) -> ()) where SuccessM: Decodable, WrongM: Decodable {
        
        return self.request(provider, target: target, successCode: 200, checkFailure: true, completion: completion)
    }
    
    internal func request<API, SuccessM, WrongM>(_ provider: MoyaProvider<API>, target: API, successCode: Int, completion: @escaping (_ result: Result<SuccessM, WrongM>) -> ()) where SuccessM: Decodable, WrongM: Decodable {
        
        return self.request(provider, target: target, successCode: successCode, checkFailure: true, completion: completion)
    }
    
    internal func request<API, SuccessM, WrongM>(_ provider: MoyaProvider<API>, target: API, checkFailure: Bool, completion: @escaping (_ result: Result<SuccessM, WrongM>) -> ()) where SuccessM: Decodable, WrongM: Decodable {
        
        return self.request(provider, target: target, successCode: 200, checkFailure: checkFailure, completion: completion)
    }
    
    
    // MARK: - Private
    
    
    // MARK: - Public
    
    public func cancelAll() {
        requests.forEach { cancellable in cancellable.cancel() }
        requests.removeAll()
    }
    
    
}
