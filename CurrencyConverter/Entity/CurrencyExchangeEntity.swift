//
//  CurrencyExchangeEntity.swift
//  CurrencyConverter
//
//  Created by Anbalagan D on 07/07/23.
//
//

import Foundation
import CoreData

@objc(CurrencyExchangeEntity)
public final class CurrencyExchangeEntity: NSManagedObject {
    @NSManaged public var baseCurrency: String
    @NSManaged public var currencySymbol: String
    @NSManaged public var rate: Double
}

extension CurrencyExchangeEntity {
    public static func fetchRequest() -> NSFetchRequest<CurrencyExchangeEntity> {
        return NSFetchRequest<CurrencyExchangeEntity>(entityName: entityName)
    }
}

extension CurrencyExchangeEntity {
    static let entityName = "CurrencyExchangeEntity"
    
    enum Key {
        static let baseCurrency = "baseCurrency"
        static let currencySymbol = "currencySymbol"
        static let rate = "rate"
    }
}

extension CurrencyExchangeEntity: DomainConvertible {
    func toDomain() -> Currency {
        return .init(symbol: currencySymbol, rate: rate, base: baseCurrency)
    }
}
