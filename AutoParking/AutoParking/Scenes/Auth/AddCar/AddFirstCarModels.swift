//
//  AddFirstCarModels.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit
import AutoParkingNetwork

enum AddFirstCar {
    
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
