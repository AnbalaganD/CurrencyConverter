//
//  CurrencyConverterApp.swift
//  CurrencyConverter
//
//  Created by Anbalagan D on 06/07/23.
//

import SwiftUI

@main
struct CurrencyConverterApp: App {
    var body: some Scene {
        WindowGroup {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    CurrencyConverterScreen()
                }
            } else {
                NavigationView {
                    CurrencyConverterScreen()
                        .navigationViewStyle(.stack)
                }
            }
        }
    }
}
