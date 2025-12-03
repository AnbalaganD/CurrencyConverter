//
//  ExchangeLocalRepositoryTests.swift
//  CurrencyConverterTests
//
//  Created by Anbalagan D on 10/07/23.
//

import Testing
import CoreData
@testable import CurrencyConverter

struct ExchangeLocalRepositoryTests {
    @Test
    func isDataSaveCorrectly() async throws {
        let coredataStack = CoreDataStack(inMemory: true)
        let localRepository = ExchangeLocalRepositoryImp(coredataStack: coredataStack)
        let dummyCurrency = Currency.getDummyCurrency()
        try await localRepository.save(currencies: dummyCurrency)
        let result = try await coredataStack.performBackgroundTask { managedObjectContext in
            let fetchRequest = CurrencyExchangeEntity.fetchRequest()
            let result = try managedObjectContext.fetch(fetchRequest)
            return result.map { $0.toDomain() }
        }
        
        #expect(result.count == dummyCurrency.count, "Error while saving data")
        
        var containsCorrectData = true
        for entity in result {
            if !dummyCurrency.contains(where: { $0.symbol == entity.symbol }) {
                containsCorrectData = false
                break
            }
        }
        
        #expect(containsCorrectData, "Error while saving data")
    }
    
    @Test
    func fetchDataCorrectly() async throws {
        let coredataStack = CoreDataStack(inMemory: true)
        let localRepository = ExchangeLocalRepositoryImp(coredataStack: coredataStack)
        let dummyCurrency = Currency.getDummyCurrency()
        try await localRepository.save(currencies: dummyCurrency)
        
        let result = try await localRepository.getCurrencies()
        
        #expect(result.count == dummyCurrency.count, "Error while fetching data")
        
        var containsCorrectData = true
        for entity in result {
            if !dummyCurrency.contains(where: { $0.symbol == entity.symbol }) {
                containsCorrectData = false
                break
            }
        }
        
        #expect(containsCorrectData, "Error while fetching data")
    }
}
