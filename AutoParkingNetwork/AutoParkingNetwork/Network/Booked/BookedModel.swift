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

import Foundation

public struct BookingListResponse: Codable {
    public let status: String?
    public let data: [Booking]?
    public let totalAmount: Double?
    public let code: Int?
}

public struct Booking: Codable {
    public let id: String?
    public var park: ParkDetail?
    public var car: CarDetail?
    public var slot: SlotDetail?
    public var startDate: String?
    public var endDate: String?
    public var endDateColor: String?
    public var headerDate: String?
    public var date: String?
    public var price: String?
    public var priceFloat: Double?
    public var paymentMethod: String?
    public var parkingRequired: Int?
    public var paid: Int?
    public var duration: Int?
    public var isLeft: Int?
    public var isFined: Int?
    public var allowCurrentPay: Int?
    public var allowFine: Bool?
    public var editable: Bool?
    public var allowIncrease: Bool?
    public var allowLeft: Bool?
    public var fromPark: String?
    public var toPark: String?
    public var leftTime: Int?
    public var startTime: Int?
    public var countType: String?
    public var allowStop: Bool?
    public var allowStopBefore: Bool?
    public var left: LeftDetail?
    public var status: BookingStatus?
    public var icons: [BookingIcon]?

    enum CodingKeys: String, CodingKey {
        case id
        case park
        case car
        case slot
        case startDate = "start_date"
        case endDate = "end_date"
        case endDateColor = "end_date_color"
        case headerDate = "header_date"
        case date
        case price
        case priceFloat = "price_float"
        case paymentMethod = "payment_method"
        case parkingRequired = "parking_required"
        case paid
        case duration
        case isLeft = "is_left"
        case isFined = "is_fined"
        case allowCurrentPay = "allow_current_pay"
        case allowFine = "allow_fine"
        case editable
        case allowIncrease = "allow_increase"
        case allowLeft = "allow_left"
        case fromPark = "from_park"
        case toPark = "to_park"
        case leftTime = "left_time"
        case startTime = "start_time"
        case countType = "count_type"
        case allowStop = "allow_stop"
        case allowStopBefore = "allow_stop_before"
        case left
        case status
        case icons
    }
}

public struct ParkDetail: Codable {
    public let id: String?
    public let code: String?
    public let title: String?
    public let center: CoordinatePoint?
    public let address: String?
    public let bookedSlotCount: Int?
    public let totalSlotCount: Int?
    public let disabled: Int?
    public let slotRequired: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case code
        case title
        case center
        case address
        case bookedSlotCount = "booked_slot_count"
        case totalSlotCount = "total_slot_count"
        case disabled
        case slotRequired = "slot_required"
    }
}

public struct CarDetail: Codable {
    public let id: String?
    public let number: String?

    enum CodingKeys: String, CodingKey {
        case id
        case number
    }
}

public struct SlotDetail: Codable {
    public let id: Int?
    public let title: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
    }
}

public struct CoordinatePoint: Codable {
    public let type: String?
    public let coordinates: [Double]?

    enum CodingKeys: String, CodingKey {
        case type
        case coordinates
    }
}

public struct LeftDetail: Codable {
    public let background: String?
    public let time: Int?

    enum CodingKeys: String, CodingKey {
        case background
        case time
    }
}

public struct BookingStatus: Codable {
    public let value: String?
    public let label: String?
    public let color: String?

    enum CodingKeys: String, CodingKey {
        case value
        case label
        case color
    }
}

public struct BookingIcon: Codable {
    public let icon: String?
    public let color: String?

    enum CodingKeys: String, CodingKey {
        case icon
        case color
    }
}
