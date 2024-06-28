//
//  AuthPlugin.swift
//  AutoParkingNetwork
//
//  Created by Saleh Majidov on 24/06/2024.
//

import Foundation
import Moya

// MARK: - AccessTokenAuth

/// A protocol for controlling the behavior of `AuthPlugin`.
public protocol AccessTokenAuth {

    /// Represents the authorization header to use for requests.
    var authType: AuthType { get }
}

// MARK: - AuthType

/// An enum representing the header to use with an `AuthPlugin`
public enum AuthType {
    /// No header.
    case none
    
    /// The `"AutoParking"` header.
    case autoParking

    /// The `"Basic"` header.
    case basic

    /// The `"Bearer"` header.
    case bearer

    /// Custom header implementation.
    case custom(String)

    public var value: String? {
        switch self {
        case .none: return nil
        case .autoParking: return nil
        case .basic: return "Basic"
        case .bearer: return "Bearer"
        case .custom(let customValue): return customValue
        }
    }
}

// MARK: - AuthPlugin

/**
 A plugin for adding basic or bearer-type authorization headers to requests. Example:

 ```
 Authentication: Basic <token>
 Authentication: Bearer <token>
 Authentication: <Сustom> <token>
 ```

*/
public struct AuthPlugin: PluginType {

    /// A closure returning the access token to be applied in the header.
    public let tokenClosure: () -> String

    /**
     Initialize a new `AccessTokenPlugin`.

     - parameters:
       - tokenClosure: A closure returning the token to be applied in the pattern `Authentication: <AuthType> <token>`
    */
    public init(tokenClosure: @escaping () -> String) {
        self.tokenClosure = tokenClosure
    }

    /**
     Prepare a request by adding an authorization header if necessary.

     - parameters:
       - request: The request to modify.
       - target: The target of the request.
     - returns: The modified `URLRequest`.
    */
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {

        guard let auth = target as? AccessTokenAuth else { return request }

        let authType = auth.authType
        var request = request

        switch authType {
        case .basic, .bearer, .custom:
            if let value = authType.value {
                let authValue = value + " " + tokenClosure()
                request.addValue(authValue, forHTTPHeaderField: "Authorization")
            }
            
        case .autoParking:
            let authValue = tokenClosure()
            if !authValue.isEmpty {
                request.addValue(authValue, forHTTPHeaderField: "Authorization")
            }
            
        case .none:
            break
        }

        return request
    }
}

