//
//  ParkModel.swift
//  AutoParkingNetwork
//
//  Created by Saleh Majidov on 25/06/2024.
//

import Foundation

// Response

public struct ParkListResponse: Decodable {
    public let status: String?
    public let description: String?
    public let data: [Park]?
    public let count: Int?
}

public struct Park: Decodable, Identifiable {
    public let id: String?
    public let code: String?
    public let number: String?
    public let title: String?
    public let address: String?
    public let cleverciti: Bool?
    public let totalSlotCount: Int?
    public let bookedSlotCount: Int?
    public let sites: String?
    public let sitesArray: SitesArray?
    public let distance: Double?
    public let distanceUnit: String?
    public let price: String?
    public let priceUnit: String?
    public let slotUnit: String?
    public let coordinates: Coordinates?
    public let polylineCoords: [Coordinates]?
    public let slotRequired: Int?
    public let disabiled: Int?
    public let zoom: Double?
    public let status: ParkStatus?
    public let color: String?
    
    
//    enum CodingKeys: String, CodingKey {
//        case id,code,number,title,address,cleverciti,sites, distance, price, coordinates, disabiled, zoom, status, color
//        case totalSlotCount = "total_slot_count"
//        case bookedSlotCount = "booked_slot_count"
//        case sitesArray = "sites_array"
//        case distanceUnit = "distance_unit"
//        case priceUnit = "price_unit"
//        case slotUnit = "slot_unit"
//        case polyLineCor = "polyline_coords"
//        case slotRequired = "slot_required"
//    }
}

public struct SitesArray: Decodable {
    public let bookedSlotCount: Int?
    public let clevercitiCount: Int?
    public let totalSlotCount: Int?
//    
//    enum CodingKeys: String, CodingKey {
//        case bookedSlotCount = "booked_slot_count"
//        case clevercitiCount = "cleverciti_count"
//        case totalSlotCount = "total_slot_count"
//    }
}

public struct Coordinates: Decodable {
    public let latitude: Double?
    public let longitude: Double?
}

public struct ParkStatus: Decodable {
    public let value: Int?
    public let label: String?
    public let color: String?
}

// Request

public struct ParkListRequest: Encodable {
    public let token: String
    public let template: String = "4"
    public let source: String = "app"
    public let type: String = "user"
    public let lang: String = "az"
    public let version: String = "20"
    public let vs: Int = 20
    public let device: String
    public let ts: String
    public let dataSkip: Int = 0
    public let dataLimit: Int = 20
    public let dataType: String = "nearest"
    public let dataKey: String = ""
    public let dataOrigin: Origin
    public let dataDisabled: Bool = false

    public struct Origin: Encodable {
        public let latitude: Double
        public let longitude: Double
        public let altitudeAccuracy: Double
        public let accuracy: Double
        public let heading: Double
        public let speed: Double
        public let altitude: Double
        
        public init(latitude: Double, longitude: Double, altitudeAccuracy: Double, accuracy: Double, heading: Double, speed: Double, altitude: Double) {
            self.latitude = latitude
            self.longitude = longitude
            self.altitudeAccuracy = altitudeAccuracy
            self.accuracy = accuracy
            self.heading = heading
            self.speed = speed
            self.altitude = altitude
        }
    }

    enum CodingKeys: String, CodingKey {
        case token, template, source, type, lang, version, vs, device, ts
        case dataSkip = "data[skip]"
        case dataLimit = "data[limit]"
        case dataType = "data[type]"
        case dataKey = "data[key]"
        case dataOrigin = "data[origin]"
        case dataDisabled = "data[disabled]"
    }

    public init(token: String, device: String, ts: String, origin: Origin) {
        self.token = token
        self.device = device
        self.ts = ts
        self.dataOrigin = origin
    }
}

public struct VehicleResponse: Codable {
    public let status: String
    public let description: String
    public let data: [Vehicle]
    public let count: Int

    public init(status: String, description: String, data: [Vehicle], count: Int) {
        self.status = status
        self.description = description
        self.data = data
        self.count = count
    }
}

public struct Vehicle: Codable, Identifiable {
    public let id: String?
    public let numberId: Int?
    public let number: String?
    public let isDefault: Int?
    public let isNational: Int?
    public let mark: VehicleDetail?
    public let model: VehicleDetail?

    enum CodingKeys: String, CodingKey {
        case id
        case numberId = "number_id"
        case number
        case isDefault = "default"
        case isNational = "national"
        case mark
        case model
    }

    public init(id: String, numberId: Int, number: String, isDefault: Int, isNational: Int, mark: VehicleDetail, model: VehicleDetail) {
        self.id = id
        self.numberId = numberId
        self.number = number
        self.isDefault = isDefault
        self.isNational = isNational
        self.mark = mark
        self.model = model
    }
}

public struct VehicleDetail: Codable {
    public let value: String?
    public let label: String?

    public init(value: String, label: String) {
        self.value = value
        self.label = label
    }
}
