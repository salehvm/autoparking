//
//  ParkService.swift
//  AutoParkingNetwork
//
//  Created by Saleh Majidov on 25/06/2024.
//

import Moya
import CoreLocation

public protocol ParkServiceProtocol: BaseServiceProtocol {

    func getParkList(token: String, location: CLLocation, completion: @escaping (Result<ParkListResponse, WrongResponse>) -> ())
    
    func getCarList(token: String, completion: @escaping (Result<VehicleResponse, WrongResponse>) -> ())
}

public class ParkService: BaseService, ParkServiceProtocol {
    
    private var provider: MoyaProvider<ParkAPI>!
    
    var timestamp = Int(Date().timeIntervalSince1970)
    
    override init() {
        super.init()
        
            #if DEBUG
            let networkLoggerPlugin = NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))
            self.provider = MoyaProvider<ParkAPI>(plugins: [self.authPlugin, networkLoggerPlugin])
            #else
            self.provider = MoyaProvider<ParkAPI>(plugins: [self.authPlugin])
            #endif

        
    }
    
    public func getParkList(token: String, location: CLLocation, completion: @escaping (Result<ParkListResponse, WrongResponse>) -> ()) {
        self.request(provider, target: .getParkList(token: token, location: location)) { result in
    
            completion(result)
        }
    }
    
    public func getCarList(token: String, completion: @escaping (Result<VehicleResponse, WrongResponse>) -> ()) {
        self.request(provider, target: .fetchCarList(token: token)) { result in
    
            completion(result)
        }
    }
}

