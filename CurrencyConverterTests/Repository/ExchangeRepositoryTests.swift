//
//  ExchangeRepositoryTests.swift
//  CurrencyConverterTests
//
//  Created by Anbalagan D on 10/07/23.
//

import XCTest
@testable import CurrencyConverter

final class ExchangeRepositoryTests: XCTestCase {

    private var localRepository: ExchangeLocalRepository!
    private var coredataStack: CoreDataStack!
    private var exchangeRepository: ExchangeRepository!
    
    override func setUpWithError() throws {
        coredataStack = CoreDataStack(inMemory: true)
        localRepository = ExchangeLocalRepositoryImp(
            coredataStack: coredataStack
        )
        
        exchangeRepository = ExchangeRepositoryImp(
            remoteRepository: ExchangeRemoteRepositoryMock(),
            localRepository: localRepository,
            cacheExpirationDurationInSecond: Constants.thirtyMinute,
            lastFetchedTime: Date().timeIntervalSinceReferenceDate,
            connectivityChecker: ConnectivityCheckerMock(isConnected: false)
        )
    }
    
    func testIsDataFetchedFromLocal() async throws {
        let dummyCurrency = Currency.getDummyCurrency()
        try await localRepository.save(currencies: dummyCurrency)
        
        let result = try await exchangeRepository.getCurrencies()
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

    override func tearDownWithError() throws {
        localRepository = nil
        coredataStack = nil
        exchangeRepository = nil
    }
}
