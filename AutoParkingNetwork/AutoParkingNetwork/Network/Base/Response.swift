//
//  Response.swift
//  AutoParkingNetwork
//
//  Created by Saleh Majidov on 24/06/2024.
//

import Foundation

public struct ApiResponse: Decodable {
    public var code: String?
    public var message: String?
}

public struct NoResponse: Decodable {}

public struct WrongResponse: Decodable {
    public var code: String?
    public var message: String?
}
