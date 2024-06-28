//
//  BookedAPI.swift
//  AutoParkingNetwork
//
//  Created by Saleh Majidov on 25/06/2024.
//

import Moya

public enum BookedAPI {
    case fetchBookingList(request: Encodable)
}

extension BookedAPI: TargetType, AccessTokenAuth {
    
    public var baseURL: URL {
        return URL(string: "https://appapi.azparking.az")!
    }

    public var path: String {
        switch self {
        case .fetchBookingList:
            return "/booking/list"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .fetchBookingList:
            return .get
        }
    }

    public var task: Task {
        switch self {
        case let .fetchBookingList(request):
            return .requestParameters(parameters: request.dictionary, encoding: URLEncoding.default)

        }
    }

    public var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }

    public var validationType: ValidationType {
        return .customCodes([200, 201, 202, 204, 304, 400, 401, 403, 404, 406, 409])
    }

    public var sampleData: Data {
        return Data()
    }
    
    public var authType: AuthType {
        switch self {
        case .fetchBookingList:
            return .autoParking
        }
    }
}

