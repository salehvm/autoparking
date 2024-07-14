//
//  VehicleManager.swift
//  AutoParking
//
//  Created by Saleh Majidov on 26/06/2024.
//

import Foundation
import AutoParkingNetwork
import RealmSwift

protocol VehicleService {
    func fetchVehicles(completion: @escaping ([Vehicle]?, Error?) -> Void)
}

class VehicleDataManager {
    let service: VehicleService
    
    init(service: VehicleService) {
        self.service = service
    }
    
    func syncVehiclesWithCache(completion: @escaping (Error?) -> Void) {
        service.fetchVehicles { vehicles, error in
            guard let vehicles = vehicles else {
                completion(error)
                return
            }
            
            let realm = try! Realm()
            try! realm.write {
                for apiVehicle in vehicles {
                    let storedVehicle = realm.object(ofType: VehicleRealm.self, forPrimaryKey: apiVehicle.id)
                    if let storedVehicle = storedVehicle {
                        // Update existing
                        storedVehicle.numberId = apiVehicle.numberId ?? 0
                        storedVehicle.number = apiVehicle.number ?? ""
                        // Other fields...
                    } else {
                        // Add new
                        let newVehicle = VehicleRealm()
                        newVehicle.id = apiVehicle.id ?? ""
                        newVehicle.numberId = apiVehicle.numberId ?? 0
                        newVehicle.number = apiVehicle.number ?? ""
                        // Other fields...
                        realm.add(newVehicle)
                    }
                }
            }
            completion(nil)
        }
    }
}

class VehicleRealm: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var numberId: Int = 0
    @objc dynamic var number: String = ""
    @objc dynamic var isDefault: Bool = false
    @objc dynamic var isNational: Bool = false
    @objc dynamic var markValue: String = ""
    @objc dynamic var markLabel: String = ""
    @objc dynamic var modelValue: String = ""
    @objc dynamic var modelLabel: String = ""
    @objc dynamic var deviceName: String = "" 
    @objc dynamic var carName: String = ""
    

    override static func primaryKey() -> String? {
        return "id"
    }
}

class AutoNotification: Object {
    @objc dynamic var isAutoCheck: Bool = true
}
