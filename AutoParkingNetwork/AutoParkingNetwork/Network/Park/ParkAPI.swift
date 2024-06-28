//
//  ParkAPI.swift
//  AutoParkingNetwork
//
//  Created by Saleh Majidov on 25/06/2024.
//

import Moya
import CoreLocation

public enum ParkAPI {
    case getParkList(token: String, location: CLLocation)
    case fetchCarList(token: String)
}

extension ParkAPI: TargetType, AccessTokenAuth {
    
    public var baseURL: URL {
        return URL(string: "https://appapi.azparking.az")!
    }

    public var path: String {
        switch self {
        case .getParkList:
            return "/parks/applist"
            
        case .fetchCarList:
            return "/cars/applist"
            
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getParkList,
             .fetchCarList:
            return .get
        }
    }

    public var task: Task {
        switch self {
        case let .getParkList(token, location):
            let origin = [
                "latitude": location.coordinate.latitude,
                "altitudeAccuracy": location.verticalAccuracy,
                "longitude": location.coordinate.longitude,
                "accuracy": location.horizontalAccuracy,
                "heading": location.course,
                "speed": location.speed,
                "altitude": location.altitude
            ]
            let originData = try? JSONSerialization.data(withJSONObject: origin, options: [])
            let originString = String(data: originData!, encoding: .utf8)!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            return .requestParameters(parameters: ["token": token, "template": "4", "source": "app", "type": "user", "lang": "az", "version": "20", "vs": "20", "device": "iOS", "ts": Int(Date().timeIntervalSince1970), "data[skip]": 0, "data[limit]": 20, "data[type]": "nearest", "data[key]": "", "data[origin]": originString!, "data[disabiled]": false], encoding: URLEncoding.queryString)
            
            
        case let .fetchCarList(token):
            return .requestParameters(parameters: ["token": token, "template": "4", "source": "app", "type": "user", "lang": "az", "version": "20", "vs": "20", "device": "iOS", "ts": Int(Date().timeIntervalSince1970), "data[skip]": 0, "data[limit]": 20, "data[sort]": "created_at", "data[sort_type]": "desc", "data[number]": ""], encoding: URLEncoding.queryString)

        }
    }

    public var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }

    public var validationType: ValidationType {
        return .customCodes([200, 201, 202, 204, 304, 400, 401, 403, 404, 406, 409])
    }

    public var sampleData: Data {
        return Data()
    }
    
    public var authType: AuthType {
        switch self {
        case .getParkList,
             .fetchCarList:
            return .autoParking
        }
    }
}

