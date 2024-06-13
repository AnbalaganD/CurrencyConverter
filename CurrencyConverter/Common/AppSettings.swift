//
//  AppSettings.swift
//  CurrencyConverter
//
//  Created by Anbalagan D on 07/07/23.
//

import Foundation

enum AppSettings {
    nonisolated(unsafe) private static let userDefaults = UserDefaults.standard
    
    static var lastFetchedTime: TimeInterval {
        get { userDefaults.double(forKey: "lastFetchedTime") }
        set { userDefaults.set(newValue, forKey: "lastFetchedTime") }
    }
    
    static var userLastSelectionCurrency: String? {
        get { userDefaults.string(forKey: "userLastSelectionCurrency") }
        set { userDefaults.set(newValue, forKey: "userLastSelectionCurrency") }
    }
    
    static func synchronize() {
        userDefaults.synchronize()
    }
    
    static func clear() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
}
