//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Anbalagan D on 09/07/23.
//

import Foundation

protocol DomainConvertible {
    associatedtype Model
    func toDomain() -> Model
}

struct Currency: Hashable, Identifiable {
    var id: String { symbol }
    
    let symbol: String
    let rate: Double
    let base: String
}
