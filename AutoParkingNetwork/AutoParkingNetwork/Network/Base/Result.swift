//
//  Result.swift
//  AutoParkingNetwork
//
//  Created by Saleh Majidov on 24/06/2024.
//

import Foundation


public enum Result<SuccessValue, WrongValue> {
    case successNoContent
    case success(SuccessValue)
    case wrong(WrongValue)
    case failure(Error)
}
