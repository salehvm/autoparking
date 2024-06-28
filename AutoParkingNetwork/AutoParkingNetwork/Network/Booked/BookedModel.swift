//
//  BookedModel.swift
//  AutoParkingNetwork
//
//  Created by Saleh Majidov on 25/06/2024.
//

import Foundation

// Request

public struct BookedListRequest: Encodable {

    public let token: String
    public let template: String
    public let source: String
    public let type: String
    public let lang: String
    public let version: String
    public let vs: Int
    public let device: String
    public let ts: String
    public let dataId: Int
    public let dataActive: Int
    public let dataSkip: Int
    public let dataLimit: Int
    public let dataSort: String
    public let dataSortType: String
    public let dataFrom: String
    public let dataType: String
    
    public enum CodingKeys: String, CodingKey {
        case token
        case template
        case source
        case type
        case lang
        case version
        case vs
        case device
        case ts
        case dataId = "data[id]"
        case dataActive = "data[active]"
        case dataSkip = "data[skip]"
        case dataLimit = "data[limit]"
        case dataSort = "data[sort]"
        case dataSortType = "data[sort_type]"
        case dataFrom = "data[from]"
        case dataType = "data[type]"
    }

    public init(token: String, template: String, source: String, type: String, lang: String, version: String, vs: Int, device: String, ts: String, dataId: Int, dataActive: Int, dataSkip: Int, dataLimit: Int, dataSort: String, dataSortType: String, dataFrom: String, dataType: String) {
        self.token = token
        self.template = template
        self.source = source
        self.type = type
        self.lang = lang
        self.version = version
        self.vs = vs
        self.device = device
        self.ts = ts
        self.dataId = dataId
        self.dataActive = dataActive
        self.dataSkip = dataSkip
        self.dataLimit = dataLimit
        self.dataSort = dataSort
        self.dataSortType = dataSortType
        self.dataFrom = dataFrom
        self.dataType = dataType
    }
}


// Response

public struct BookingListResponse: Codable {
    public let status: String?
    public let data: [Booking]?
    public let total_amount: Double?
    public let code: Int?
}

public struct Booking: Codable, Identifiable {
    public let id: String?
    public var park: ParkDetail?
    public var car: CarDetail?
    public var slot: SlotDetail?
    public var start_date: String?
    public var end_date: String?
    public var end_date_color: String?
    public var header_date: String?
    public var date: String?
    public var price: String?
    public var price_float: Double?
    public var payment_method: String?
    public var parking_required: Bool?
    public var paid: Int?
    public var duration: Double?
    public var is_left: Bool?
    public var is_fined: Bool?
    public var allow_current_pay: Bool?
    public var allow_fine: Bool?
    public var editable: Bool?
    public var allow_increase: Bool?
    public var allow_left: Bool?
    public var from_park: String?
    public var to_park: String?
    public var left_time: Double?
    public var start_time: Int?
    public var count_type: String?
    public var allow_stop: Bool?
    public var allow_stop_before: Bool?
    public var left: LeftDetail?
    public var status: BookingStatus?
    public var icons: [BookingIcon]?
}

public struct ParkDetail: Codable {
    public let id: String?
    public let code: String?
    public let title: String?
    public let center: CoordinatePoint?
    public let address: String?
    public let booked_slot_count: Int?
    public let total_slot_count: Int?
    public let disabled: Bool?
    public let slot_required: Bool?
}

public struct CarDetail: Codable {
    public let id: String?
    public let number: String?
}

public struct SlotDetail: Codable {
    public let id: Int?
    public let title: String?
}

public struct CoordinatePoint: Codable {
    public let type: String?
    public let coordinates: [Double]?
}

public struct LeftDetail: Codable {
    public let background: String?
    public let time: Double?
}

public struct BookingStatus: Codable {
    public let value: String?
    public let label: String?
    public let color: String?
}

public struct BookingIcon: Codable {
    public let icon: String?
    public let color: String?
}
