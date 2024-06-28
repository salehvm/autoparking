//
//  AppDefaults.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import Foundation

final class AppDefaults {
    
    static let defaults = UserDefaults.standard
    
    // MARK: Setters
    
    static func setObject(key: String, value: AnyObject) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    static func setString(key: String, value: String) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    static func setInteger(key: String, value: Int) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    static func setDouble(key: String, value: Double) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    static func setFloat(key: String, value: Float) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    static func setBool(key: String, value: Bool) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    
    // MARK: Getters
    
    static func getObject(key: String) -> AnyObject? {
        return defaults.object(forKey: key) as AnyObject?
    }
    
    static func getString(key: String) -> String? {
        return defaults.string(forKey: key)
    }
    
    static func getInteger(key: String) -> Int {
        return defaults.integer(forKey: key)
    }
    
    static func getDouble(key: String) -> Double {
        return defaults.double(forKey: key)
    }
    
    static func getFloat(key: String) -> Float {
        return defaults.float(forKey: key)
    }
    
    static func getBool(key: String) -> Bool {
        return defaults.bool(forKey: key)
    }
    
    // MARK: Remover
    
    static func remove(key: String) {
        defaults.removeObject(forKey: key)
        defaults.synchronize()
    }
}
