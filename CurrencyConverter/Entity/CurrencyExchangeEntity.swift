//
//  CurrencyExchangeEntity.swift
//  CurrencyConverter
//
//  Created by Anbalagan D on 07/07/23.
//
//

import Foundation
public import CoreData

@objc(CurrencyExchangeEntity)
public final class CurrencyExchangeEntity: NSManagedObject {
    @NSManaged public var baseCurrency: String
    @NSManaged public var currencySymbol: String
    @NSManaged public var rate: Double
}

extension CurrencyExchangeEntity {
    nonisolated
    public static func fetchRequest() -> NSFetchRequest<CurrencyExchangeEntity> {
        NSFetchRequest<CurrencyExchangeEntity>(entityName: entityName)
    }
}

extension CurrencyExchangeEntity {
    nonisolated
    static let entityName = "CurrencyExchangeEntity"
    
    nonisolated
    enum Key {
        static let baseCurrency = "baseCurrency"
        static let currencySymbol = "currencySymbol"
        static let rate = "rate"
    }
}

extension CurrencyExchangeEntity: DomainConvertible {
    nonisolated
    func toDomain() -> Currency {
        .init(symbol: currencySymbol, rate: rate, base: baseCurrency)
    }
}
