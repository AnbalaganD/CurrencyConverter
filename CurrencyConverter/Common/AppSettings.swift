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
        get { unsafe userDefaults.double(forKey: "lastFetchedTime") }
        set { unsafe userDefaults.set(newValue, forKey: "lastFetchedTime") }
    }
    
    static var userLastSelectionCurrency: String? {
        get { unsafe userDefaults.string(forKey: "userLastSelectionCurrency") }
        set { unsafe userDefaults.set(newValue, forKey: "userLastSelectionCurrency") }
    }
    
    static func synchronize() {
        unsafe userDefaults.synchronize()
    }
    
    static func clear() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
}
