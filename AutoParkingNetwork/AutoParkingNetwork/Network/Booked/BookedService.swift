//
//  BookedService.swift
//  AutoParkingNetwork
//
//  Created by Saleh Majidov on 25/06/2024.
//

import Moya

public protocol BookedServiceProtocol: BaseServiceProtocol {

    func getBookedList(request: BookedListRequest, completion: @escaping (Result<BookingListResponse, WrongResponse>) -> ())
}

public class BookedService: BaseService, BookedServiceProtocol {
    
    private var provider: MoyaProvider<BookedAPI>!
    
    var timestamp = Int(Date().timeIntervalSince1970)
    
    override init() {
        super.init()
        
            #if DEBUG
            let networkLoggerPlugin = NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))
            self.provider = MoyaProvider<BookedAPI>(plugins: [self.authPlugin, networkLoggerPlugin])
            #else
            self.provider = MoyaProvider<BookedAPI>(plugins: [self.authPlugin])
            #endif

        
    }
    
    public func getBookedList(request: BookedListRequest, completion: @escaping (Result<BookingListResponse, WrongResponse>) -> ()) {
        self.request(provider, target: .fetchBookingList(request: request)) { result in
    
            completion(result)
        }
    }
}
