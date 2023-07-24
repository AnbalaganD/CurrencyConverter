//
//  NetworkStubHelper.swift
//  CurrencyConverterTests
//
//  Created by Anbalagan D on 09/07/23.
//

import Foundation

final class NetworkStubHelper {
    static let shared = NetworkStubHelper()
    private init() { }
    
    func getExchangeCurrencyData() -> Data? {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "exchange_currency", withExtension: "json") else {
            return nil
        }
        
        return try? Data(contentsOf: url)
    }
}
