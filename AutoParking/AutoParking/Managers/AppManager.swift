//
//  AppManager.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import Foundation
import AutoParkingNetwork

final class AppManager {
    
    static let shared = AppManager()
    
    private var service: ServiceProtocol = App.service
    
    private var session: SessionManagerProtocol = SessionManager.shared
    
    
    // MARK: - Inits
    
    init() {
        self.service.delegate = self
        self.service.dataSource = self
    }
    
    func start() { }
    
    func logout() {
        self.session.logout()
        
        App.router.signIn()
    }
}

// MARK: - Service Delegate

extension AppManager: ServiceDelegate {
    
    func unauthorizedError() {
        self.logout()
    }
    
}

// MARK: - Service DataSource

extension AppManager: ServiceDataSource {
    
    func getAccessToken() -> String? {
        return self.session.accessToken
    }
    
    func checkFailure(_ isNoInternet: Bool, completion: @escaping (Bool) -> Void) {
        AlertViewManager.shared.showRequestError(isNoInternet) { isTry in
            completion(isTry)
        }
    }
}
