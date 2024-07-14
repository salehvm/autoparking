//
//  SessionManager.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import Foundation
import AutoParkingNetwork

protocol SessionManagerProtocol {
    
    var hasLogin: Bool { get set }
    var hasOnboarding: Bool { get set }
    
    var accessToken: String? { get set }
    
    var phoneNumber: String? { get set }
    var userId: String? { get set }
    
    func logout()
}

final class SessionManager: NSObject, SessionManagerProtocol {
    
    static let shared = SessionManager()
    
    var user: UserData? = nil
    
    var hasLogin: Bool {
        get {
            return AppDefaults.getBool(key: AppKeys.User.Login)
        }
        set {
            AppDefaults.setBool(key: AppKeys.User.Login, value: newValue)
        }
    }
    
    var hasOnboarding: Bool {
        get {
            return AppDefaults.getBool(key: AppKeys.App.Onboarding)
        }
        set {
            AppDefaults.setBool(key: AppKeys.App.Onboarding, value: newValue)
        }
    }
    
    var accessToken: String? {
        get {
            return AppDefaults.getString(key: AppKeys.User.AccessToken)
        }
        set {
            if let value = newValue {
                AppDefaults.setString(key: AppKeys.User.AccessToken, value: value)
            } else {
                AppDefaults.remove(key: AppKeys.User.AccessToken)
            }
        }
    }
    
    var phoneNumber: String? {
        get {
            return AppDefaults.getString(key: AppKeys.User.PhoneNumber)
        }
        set {
            if let value = newValue {
                AppDefaults.setString(key: AppKeys.User.PhoneNumber, value: value)
            } else {
                AppDefaults.remove(key: AppKeys.User.PhoneNumber)
            }
        }
    }
    
    var userId: String? {
        get {
            return AppDefaults.getString(key: AppKeys.User.UserId)
        }
        set {
            if let value = newValue {
                AppDefaults.setString(key: AppKeys.User.UserId, value: value)
            } else {
                AppDefaults.remove(key: AppKeys.User.UserId)
            }
        }
    }

    // MARK: - Inits
    
    override init() {
        super.init()
    }
    
    // MARK: - Public
    
    func logout() {
        self.hasLogin = false
        
        self.accessToken = nil
        
        self.phoneNumber = nil
        self.userId = nil
    }
}

struct AppKeys {
    
    struct User {
        static let Login = "login"
        
        static let AccessToken = "access_token"
        
        static let PhoneNumber = "phone_number"
        static let UserId = "user_id"
    }
    
    struct App {
        static let Onboarding = "onboarding"
    }
}

