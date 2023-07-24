//
//  CurrencyExtension.swift
//  CurrencyConverterTests
//
//  Created by Anbalagan D on 10/07/23.
//

import Foundation
@testable import CurrencyConverter

extension Currency {
    static func getDummyCurrency() -> [Currency] {
        let builder = CurrencyBuilder.make()
        
        return [
            builder.setCurrencySymbol("AED").build(),
            builder.setCurrencySymbol("INR").build(),
            builder.setCurrencySymbol("JPY").build(),
            builder.setCurrencySymbol("TRY").build(),
            builder.setCurrencySymbol("WST").build(),
            builder.setCurrencySymbol("XOF").build()
        ]
    }
}
