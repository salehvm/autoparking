//
//  ActiveParkingWorker.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit
import AutoParkingNetwork

protocol ActiveParkingWorkingLogic {
    func getBookedList(token: String, completion: @escaping (BookingListResponse?, String?) -> Void)
}

final class ActiveParkingWorker: ActiveParkingWorkingLogic {

    // MARK: - Private Properties
    
    private let service: ServiceProtocol = App.service

    // MARK: - Working Logic
    
    func getBookedList(token: String, completion: @escaping (BookingListResponse?, String?) -> Void) {
        
        let ts = Int(Date().timeIntervalSince1970)
        
        let request = BookedListRequest(token: token,
                                        template: "4",
                                        source: "20",
                                        type: "user",
                                        lang: "az",
                                        version: "20",
                                        vs: 20,
                                        device: "iOS",
                                        ts: "\(ts)",
                                        dataId: 0,
                                        dataActive: 1,
                                        dataSkip: 0,
                                        dataLimit: 10,
                                        dataSort: "created_at",
                                        dataSortType: "desc",
                                        dataFrom: "time",
                                        dataType: "ongoing")
        
        service.book.getBookedList(request: request) { result in
            switch result {
            case .success(let response):
                
                print("Success: \(response)")
                completion(response, nil)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(nil, nil)
            case .successNoContent:
                break
            case .wrong(let response):
                let message = response.message
                completion(nil, message)
            }
        }
    }
    
}
