//
//  ExchangeLocalRepository.swift
//  CurrencyConverter
//
//  Created by Anbalagan D on 09/07/23.
//

import CoreData
import Foundation

protocol ExchangeLocalRepository: Sendable {
    func getCurrencies() async throws -> [Currency]
    func save(currencies: [Currency]) async throws
}

final class ExchangeLocalRepositoryImp: ExchangeLocalRepository {
    private let coredataStack: CoreDataStack
    init(coredataStack: CoreDataStack = .shared) {
        self.coredataStack = coredataStack
    }
    
    func getCurrencies() async throws -> [Currency] {
        do {
            return try await coredataStack.performBackgroundTask { managedObjectContext in
                let fetchRequest = CurrencyExchangeEntity.fetchRequest()
                fetchRequest.sortDescriptors = [
                    NSSortDescriptor(keyPath: \CurrencyExchangeEntity.currencySymbol, ascending: true),
                ]
                let result = try managedObjectContext.fetch(fetchRequest)
                return result.map { $0.toDomain() }
            }
        } catch {
            throw DatabaseError.emptyLocalData
        }
    }
    
    func save(currencies: [Currency]) async throws {
        try await coredataStack.performBackgroundTask { [weak self] managedObjectContext in
            guard let self = self else { return }
            do {
                let isDeletedSucceded = try self.deleteCurrencies(
                    managedObjectContext: managedObjectContext
                )
                
                // To ensure whether the deletion operation succeeded or not
                // If not, throw correct error to caller
                if !isDeletedSucceded {
                    throw DatabaseError.saveError(reason: "Perform batch delete operation failed")
                }
                
                try self.insert(currencies: currencies, managedObjectContext: managedObjectContext)
                try managedObjectContext.saveIfNecessary()
            } catch {
                throw DatabaseError.saveError(reason: error.localizedDescription)
            }
        }
    }
    
    private func deleteCurrencies(managedObjectContext: NSManagedObjectContext) throws -> Bool {
        let fetchRequest: NSFetchRequest<any NSFetchRequestResult> = CurrencyExchangeEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(
            fetchRequest: fetchRequest
        )
        deleteRequest.resultType = .resultTypeStatusOnly
        let result = try managedObjectContext.execute(deleteRequest)
        let batchDeleteResult = result as! NSBatchDeleteResult
        
        return batchDeleteResult.result as? Bool ?? false
    }
    
    private func insert(
        currencies: [Currency],
        managedObjectContext: NSManagedObjectContext
    ) throws {
        var index = 0
        let insertBatchRequest = NSBatchInsertRequest(entityName: CurrencyExchangeEntity.entityName) { dict in
            if index >= currencies.count { return true }
            
            let currency = currencies[index]
            let item: [String: Any] = [
                CurrencyExchangeEntity.Key.baseCurrency: currency.base,
                CurrencyExchangeEntity.Key.currencySymbol: currency.symbol,
                CurrencyExchangeEntity.Key.rate: currency.rate,
            ]
            dict.setDictionary(item)
            index += 1
            return false
        }
        insertBatchRequest.resultType = .statusOnly
        try managedObjectContext.execute(insertBatchRequest)
    }
}
