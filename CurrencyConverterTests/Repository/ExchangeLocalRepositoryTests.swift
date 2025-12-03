//
//  ExchangeLocalRepositoryTests.swift
//  CurrencyConverterTests
//
//  Created by Anbalagan D on 10/07/23.
//

import XCTest
@testable import CurrencyConverter

final class ExchangeLocalRepositoryTests: XCTestCase {
    private var localRepository: ExchangeLocalRepository!
    private var coredataStack: CoreDataStack!
    
    override func setUpWithError() throws {
        coredataStack = CoreDataStack(inMemory: true)
        localRepository = ExchangeLocalRepositoryImp(
            coredataStack: coredataStack
        )
    }
    
    func testIsDataSaveCorrectly() async throws {
        let dummyCurrency = Currency.getDummyCurrency()
        try await localRepository.save(currencies: dummyCurrency)
        let result = try await coredataStack.performBackgroundTask { managedObjectContext in
            let fetchRequest = CurrencyExchangeEntity.fetchRequest()
            let result = try managedObjectContext.fetch(fetchRequest)
            return result.map { $0.toDomain() }
        }
        
        XCTAssertTrue(result.count == dummyCurrency.count, "Error while saving data")
        
        var containsCorrectData = true
        for entity in result {
            if !dummyCurrency.contains(where: { $0.symbol == entity.symbol }) {
                containsCorrectData = false
                break
            }
        }
        
        XCTAssertTrue(containsCorrectData, "Error while saving data")
    }
    
    func testFetchDataCorrectly() async throws {
        let dummyCurrency = Currency.getDummyCurrency()
        try await localRepository.save(currencies: dummyCurrency)
        
        let result = try await localRepository.getCurrencies()
        
        XCTAssertTrue(result.count == dummyCurrency.count, "Error while fetching data")
        
        var containsCorrectData = true
        for entity in result {
            if !dummyCurrency.contains(where: { $0.symbol == entity.symbol }) {
                containsCorrectData = false
                break
            }
        }
        
        XCTAssertTrue(containsCorrectData, "Error while fetching data")
    }
    
    override func tearDownWithError() throws {
        localRepository = nil
        coredataStack = nil
    }
}
