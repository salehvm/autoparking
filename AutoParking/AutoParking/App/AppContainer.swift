//
//  AppContainer.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import Foundation
import AutoParkingUIKit
import AutoParkingNetwork

let App = AppContainer()

final class AppContainer {
    
    let router = AppRouter()
    let theme = AppTheme()
    let service = Service()

}

