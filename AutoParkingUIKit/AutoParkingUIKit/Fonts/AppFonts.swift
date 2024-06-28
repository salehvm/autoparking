//
//  AppFonts.swift
//  AutoParkingUIKit
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

public enum AppFonts {
    case boldTitleSize20
    case boldTitleSize18
    case boldBodySize16
    case boldBodySize14
    case boldBodySize12
    case regularBodySize14
    case regularBodySize12
}

extension AppFonts {
    public var fontStyle: UIFont {
        switch self {
        case .boldTitleSize20:
            return .systemFont(ofSize: 20, weight: .bold)
        case .boldTitleSize18:
            return .systemFont(ofSize: 18, weight: .bold)
        case .boldBodySize16:
            return .systemFont(ofSize: 16, weight: .bold)
        case .boldBodySize14:
            return .systemFont(ofSize: 14, weight: .bold)
        case .boldBodySize12:
            return .systemFont(ofSize: 12, weight: .bold)
        case .regularBodySize14:
            return .systemFont(ofSize: 14, weight: .regular)
        case .regularBodySize12:
            return .systemFont(ofSize: 12, weight: .regular)
        }
    }
}

