//
//  ExchangeRepository.swift
//  CurrencyConverter
//
//  Created by Anbalagan D on 06/07/23.
//

import Foundation

protocol ExchangeRepository {
    func getCurrencies() async throws -> [Currency]
}

final class ExchangeRepositoryImp: ExchangeRepository {
    private let remoteRepository: ExchangeRemoteRepository
    private let localRepository: ExchangeLocalRepository
    private let cacheExpirationDurationInSecond: Int
    private let lastFetchedTime: TimeInterval
    private let connectivityChecker: ConnectivityChecker
    
    init(
        remoteRepository: ExchangeRemoteRepository,
        localRepository: ExchangeLocalRepository,
        cacheExpirationDurationInSecond: Int,
        lastFetchedTime: TimeInterval = AppSettings.lastFetchedTime,
        connectivityChecker: ConnectivityChecker = ConnectivityCheckerImp.shared
    ) {
        self.remoteRepository = remoteRepository
        self.localRepository = localRepository
        self.cacheExpirationDurationInSecond = cacheExpirationDurationInSecond
        self.lastFetchedTime = lastFetchedTime
        self.connectivityChecker = connectivityChecker
    }
    
    func getCurrencies() async throws -> [Currency] {
        if !connectivityChecker.isConnected {
            return try await localRepository.getCurrencies()
        }
        
        let currentTimeInterval = Date().timeIntervalSinceReferenceDate

        if lastFetchedTime != 0.0 &&
            lastFetchedTime > currentTimeInterval - Double(cacheExpirationDurationInSecond) {
            return try await localRepository.getCurrencies()
        }
        
        let result = try await remoteRepository.getCurrencies()
        let currencies = result.sorted { $0.symbol < $1.symbol }
        AppSettings.lastFetchedTime = currentTimeInterval

        try await localRepository.save(currencies: currencies)
        return currencies
    }
}
