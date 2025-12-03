//
//  ExchangeRepositoryTests.swift
//  CurrencyConverterTests
//
//  Created by Anbalagan D on 10/07/23.
//

import Testing
import Foundation
@testable import CurrencyConverter

struct ExchangeRepositoryTests {
    @Test
    func isDataFetchedFromLocal() async throws {
        let coredataStack = CoreDataStack(inMemory: true)
        let localRepository = ExchangeLocalRepositoryImp(
            coredataStack: coredataStack
        )
        
        let exchangeRepository = ExchangeRepositoryImp(
            remoteRepository: ExchangeRemoteRepositoryMock(),
            localRepository: localRepository,
            cacheExpirationDurationInSecond: Constants.thirtyMinute,
            lastFetchedTime: Date().timeIntervalSinceReferenceDate,
            connectivityChecker: ConnectivityCheckerMock(isConnected: false)
        )
        
        let dummyCurrency = Currency.getDummyCurrency()
        try await localRepository.save(currencies: dummyCurrency)
        
        let result = try await exchangeRepository.getCurrencies()
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
}
