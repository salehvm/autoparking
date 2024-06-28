//
//  Service.swift
//  AutoParkingNetwork
//
//  Created by Saleh Majidov on 24/06/2024.
//

import Foundation
import Moya

// Protocol Definitions
public protocol ServiceDelegate: AnyObject {
    func unauthorizedError()
}

public protocol ServiceDataSource: AnyObject {
    func getAccessToken() -> String?
    func checkFailure(_ isNoInternet: Bool, completion: @escaping (Bool) -> Void)
}

// Service Protocol
public protocol ServiceProtocol {
    var delegate: ServiceDelegate? { get set }
    var dataSource: ServiceDataSource? { get set }
    var auth: AuthServiceProtocol { get }
    var book: BookedServiceProtocol { get }
    var park: ParkServiceProtocol { get }
    func cancelAll()
}

// Service Class
public class Service: ServiceProtocol {
    public enum Error: Swift.Error {
        case networkError
        case unauthorizedError
        case serializationError(internal: Swift.Error)
        case nonJSONResponse
    }
    
    public weak var delegate: ServiceDelegate? {
        didSet {
            self.auth.delegate = self
            self.book.delegate = self
            self.park.delegate = self
        }
    }
    
    public weak var dataSource: ServiceDataSource? {
        didSet {
            self.auth.dataSource = self
            self.book.dataSource = self
            self.park.dataSource = self
        }
    }
    
    public var auth: AuthServiceProtocol = AuthService()
    public var book: BookedServiceProtocol = BookedService()
    public var park: ParkServiceProtocol = ParkService()
    
    public init() {}
    
    public func cancelAll() {
        self.auth.cancelAll()
        self.book.cancelAll()
        self.park.cancelAll()
    }
}

// BaseService Delegate and DataSource Extensions
extension Service: BaseServiceDelegate, BaseServiceDataSource {
    public func unauthorizedError() {
        self.delegate?.unauthorizedError()
    }
    
    public func getAccessToken() -> String? {
        self.dataSource?.getAccessToken()
    }
    
    public func checkFailure(_ isNoInternet: Bool, completion: @escaping (Bool) -> Void) {
        self.dataSource?.checkFailure(isNoInternet, completion: completion)
    }
}
