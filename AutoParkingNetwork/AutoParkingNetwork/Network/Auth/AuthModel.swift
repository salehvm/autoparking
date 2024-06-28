//
//  AuthModel.swift
//  AutoParkingNetwork
//
//  Created by Saleh Majidov on 24/06/2024.
//

import Foundation

// MARK: - Response & Request

public struct Step1Response: Decodable {
    public let status: String?
    public let description: String?
    public let data: Step1Data?
    public let count: Int?
}

public struct Step1Data: Decodable {
    public let expiration_time: Int?
    public let hash: String?
    public let from: String?
    public let is_exists: Bool?
    
}

// Step2 request


public struct Step2Request: Encodable {
    public let template: String
    public let source: String
    public let type: String
    public let lang: String
    public let version: String
    public let vs: String
    public let device: String
    public let ts: Int
    public let dataCode: String
    public let dataHash: String
    public let dataOptions: String
    
    
    public enum CodingKeys: String, CodingKey {
        case template
        case source
        case type
        case lang
        case version
        case vs
        case device
        case ts
        case dataCode = "data[code]"
        case dataHash = "data[hash]"
        case dataOptions = "data[options]"
    }

   
    
    public init(template: String, source: String, type: String, lang: String, version: String, vs: String, device: String, ts:Int, dataCode: String, dataHash:String, dataOptions: String ) {
        self.template = template
        self.source = source
        self.type = type
        self.lang = lang
        self.version = version
        self.vs = vs
        self.device = device
        self.ts = ts
        self.dataCode = dataCode
        self.dataHash = dataHash
        self.dataOptions = dataOptions
    }
}

public struct Step2Response: Codable {
    public let status: String?
    public let description: String?
    public let data: Step2DataWrapper?
    public let count: Int?
}

public struct Step2DataWrapper: Codable {
    public let data: UserData?
    public let token: String?
}

public struct UserData: Codable {
    public let id: String?
    public let number_id: Int?
    public let firstname: String?
    public let lastname: String?
    public let email: String?
    public let options: [String]?
    public let active_parking: Bool?
    public let msisdn: String?
    public let `operator`: Int?
    public let type: String?
    public let birthdate: String?
    public let balance: Double?
    public let currency: Int?
    public let active: Int?
    public let sex: String?
    public let lang: String?
    public let is_deleted: Int?
}


public struct PaymentMethodResponse: Codable {
    public let status: String
    public let description: String
    public let data: [PaymentMethod]
    public let count: Int
}

public struct PaymentMethod: Codable, Identifiable {
    public let id: String
    public let method: String
    public let type: String
    public let title: String
    public let `default`: Int
    public let createdAt: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case method
        case type
        case title
        case `default`
        case createdAt = "created_at"
    }
}

public struct BookingAddResponse: Codable {
    public let status: String
    public let description: String?
    public let data: BookingAddData?
}

public struct BookingAddData: Codable {
    public let balance: Double
    public let id: Id
}

public struct Id: Codable {
    public let oid: String

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        oid = try container.decode(String.self, forKey: .oid)
    }

    private enum CodingKeys: String, CodingKey {
        case oid = "$oid"
    }
}

public struct BookingStopResponse: Codable {
    public let status: String
    public let description: String?
    public let data: [String: String]?
}
