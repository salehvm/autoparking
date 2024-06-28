//
//  Colors.swift
//  AutoParkingUIKit
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

public enum ColorStyle: String, CaseIterable {
    
    case mainColor = "Main"
}

extension ColorStyle {
    func load() -> UIColor? {
        if #available(iOS 13.0, *) {
            return UIColor(named: self.rawValue, in: bundle, compatibleWith: .current)
        } else {
            return UIColor(named: self.rawValue, in: bundle, compatibleWith: nil)
        }
    }
}


