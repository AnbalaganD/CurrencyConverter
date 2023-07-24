//
//  CurrencyBuilder.swift
//  CurrencyConverterTests
//
//  Created by Anbalagan D on 10/07/23.
//

import Foundation
@testable import CurrencyConverter

final class CurrencyBuilder {
    private var base: String = ""
    private var symbol: String = ""
    private var rate: Double = 0.0
    
    private init() { }
    
    static func make() -> CurrencyBuilder {
        return CurrencyBuilder()
    }
    
    func setBase(currency: String) -> Self {
        base = currency
        return self
    }
    
    func setCurrencySymbol(_ symbol: String) -> Self {
        self.symbol = symbol
        return self
    }
    
    func setCurrency(rate: Double) -> Self {
        self.rate = rate
        return self
    }
    
    func build() -> Currency {
        .init(
            symbol: symbol,
            rate: rate,
            base: base
        )
    }
}
