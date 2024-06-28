//
//  MyCarsModels.swift
//  AutoParking
//
//  Created by Saleh Majidov on 26/06/2024.
//

import UIKit
import AutoParkingNetwork

enum MyCars {
    
    // MARK: Use cases
  
    enum Load {
        
        struct Request {
        }
        
        struct Response {
        }
        
        struct ViewModel {
        }
    }
    
    enum VehicleList {
        
        struct Request {
        }
        
        struct Response {
            let data: [Vehicle]
        }
        
        struct ViewModel {
            let data: [Vehicle]
        }
    }
}
