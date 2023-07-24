//
//  CurrencyExchange.swift
//  CurrencyConverter
//
//  Created by Anbalagan D on 06/07/23.
//

import Foundation

struct CurrencyExchangeDTO: Decodable, Equatable {
    let disclaimer: String
    let license: String
    let timestamp: Int
    let base: String
    let rates: [String: Double]
}

extension CurrencyExchangeDTO: DomainConvertible {
    func toDomain() -> [Currency] {
        rates.map { .init(symbol: $0.key, rate: $0.value, base: base) }
    }
}
