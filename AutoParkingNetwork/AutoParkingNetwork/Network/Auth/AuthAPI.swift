//
//  AuthAPI.swift
//  AutoParkingNetwork
//
//  Created by Saleh Majidov on 24/06/2024.
//

import Moya
import CoreLocation

public enum AuthAPI {
    case step1(operatorValue: String, number: String, ts: Int)
    case step2(request: Encodable)
    case fetchParkList(token: String, location: CLLocation)
//    case fetchBookingList(token: String)
    case addBooking(token: String, parkId: String, selectedCarId: String, selectedPaymentMethod: PaymentMethod)
    case stopBooking(token: String, userParkId: String)
    case fetchCarList(token: String)
    case logout(token: String)
    case fetchPaymentMethods(token: String)
}

extension AuthAPI: TargetType, AccessTokenAuth {
    
    public var baseURL: URL {
        return URL(string: "https://appapi.azparking.az")!
    }

    public var path: String {
        switch self {
        case .step1:
            return "/auth/step1"
        case .step2:
            return "/auth/step2"
        case .fetchParkList:
            return "/parks/applist"
//        case .fetchBookingList:
//            return "/booking/list"
        case .addBooking:
            return "/booking/add/pay"
        case .stopBooking:
            return "/booking/stop"
        case .fetchCarList:
            return "/cars/applist"
        case .logout:
            return "/account/logout"
        case .fetchPaymentMethods:
            return "/cards/paymentmethods/list"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .step1, .step2, .fetchParkList, 
//                .fetchBookingList,
                .fetchCarList, .logout, .fetchPaymentMethods, .addBooking,
                 .stopBooking:
            return .get
        }
    }

    public var task: Task {
        switch self {
        case let .step1(operatorValue, number, ts):
            return .requestParameters(parameters: ["data[operator]": operatorValue, "data[dial_code]": "994", "data[number]": number, "template": "4", "source": "app", "type": "user", "lang": "az", "version": "20", "vs": "20", "device": "iOS", "ts": ts], encoding: URLEncoding.queryString)
        case .step2(let request):
            return .requestParameters(parameters: request.dictionary, encoding: URLEncoding.default)

        case let .fetchParkList(token, location):
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
            
            
//        case let .fetchBookingList(token):
//            return .requestParameters(parameters: ["token": token, "template": "4", "source": "app", "type": "user", "lang": "az", "version": "20", "vs": "20", "device": "iOS", "ts": Int(Date().timeIntervalSince1970), "data[id]": "", "data[active]": 1, "data[skip]": 0, "data[limit]": 10, "data[sort]": "created_at", "data[sort_type]": "desc", "data[from]": "time", "data[type]": "ongoing"], encoding: URLEncoding.queryString)
            
            
            
        case let .addBooking(token, parkId, selectedCarId, selectedPaymentMethod):
            return .requestParameters(parameters: ["token": token, "template": "4", "source": "app", "type": "user", "lang": "az", "version": "20", "vs": "20", "device": "iOS", "ts": Int(Date().timeIntervalSince1970), "data[park]": parkId, "data[slot]": "", "data[car]": selectedCarId, "data[price]": 3600, "data[time][value]": 3600, "data[time][label]": "1 saat", "data[time][time]": 3600, "data[time][amount]": 0.7, "data[time][price]": "0.7 AZN", "data[payment_method][id]": selectedPaymentMethod.id, "data[payment_method][type]": selectedPaymentMethod.method, "data[payment_method][text]": selectedPaymentMethod.title, "data[payment_method][icon]": selectedPaymentMethod.type, "data[payment_method][expired]": false, "data[payment_method][logo][type]": "icon", "data[payment_method][logo][value]": selectedPaymentMethod.type, "data[payment_method][default]": selectedPaymentMethod.default, "data[payment_type]": "after"], encoding: URLEncoding.queryString)
            
            
            
        case let .stopBooking(token, userParkId):
            return .requestParameters(parameters: ["token": token, "template": "4", "source": "app", "type": "user", "lang": "az", "version": "20", "vs": "20", "device": "iOS", "ts": Int(Date().timeIntervalSince1970), "data[user_park]": userParkId], encoding: URLEncoding.queryString)
        case let .fetchCarList(token):
            return .requestParameters(parameters: ["token": token, "template": "4", "source": "app", "type": "user", "lang": "az", "version": "20", "vs": "20", "device": "iOS", "ts": Int(Date().timeIntervalSince1970), "data[skip]": 0, "data[limit]": 20, "data[sort]": "created_at", "data[sort_type]": "desc", "data[number]": ""], encoding: URLEncoding.queryString)
        case let .logout(token):
            return .requestParameters(parameters: ["token": token, "template": "4", "source": "app", "type": "user", "lang": "az", "version": "20", "vs": "20", "device": "iOS", "ts": Int(Date().timeIntervalSince1970)], encoding: URLEncoding.queryString)
        case let .fetchPaymentMethods(token):
            return .requestParameters(parameters: ["token": token, "template": "4", "source": "app", "type": "user", "lang": "az", "version": "20", "vs": "20", "device": "iOS", "ts": Int(Date().timeIntervalSince1970)], encoding: URLEncoding.queryString)
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
        case .step1,
             .step2,
             .fetchParkList,
//             .fetchBookingList,
             .addBooking,
             .stopBooking,
             .fetchCarList,
             .logout,
             .fetchPaymentMethods:
            return .autoParking
        }
    }
}
