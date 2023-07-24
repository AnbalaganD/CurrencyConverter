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
public class CurrencyExchangeEntity: NSManagedObject {
    @NSManaged public var baseCurrency: String
    @NSManaged public var currencySymbol: String
    @NSManaged public var rate: Double
}

extension CurrencyExchangeEntity {
    public static func fetchRequest() -> NSFetchRequest<CurrencyExchangeEntity> {
        return NSFetchRequest<CurrencyExchangeEntity>(entityName: "CurrencyExchangeEntity")
    }
}

extension CurrencyExchangeEntity: DomainConvertible {
    func toDomain() -> Currency {
        return .init(symbol: currencySymbol, rate: rate, base: baseCurrency)
    }
}
