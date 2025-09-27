//
//  ExchangeRepository.swift
//  CurrencyConverter
//
//  Created by Anbalagan D on 06/07/23.
//

import Foundation

protocol ExchangeRepository: Sendable {
    func getCurrencies() async throws -> [Currency]
}

final class ExchangeRepositoryImp: ExchangeRepository {
    private let remoteRepository: any ExchangeRemoteRepository
    private let localRepository: any ExchangeLocalRepository
    private let cacheExpirationDurationInSecond: Int
    private let lastFetchedTime: TimeInterval
    private let connectivityChecker: any ConnectivityChecker

    init(
        remoteRepository: any ExchangeRemoteRepository,
        localRepository: any ExchangeLocalRepository,
        cacheExpirationDurationInSecond: Int,
        lastFetchedTime: TimeInterval = AppSettings.lastFetchedTime,
        connectivityChecker: any ConnectivityChecker = ConnectivityCheckerImp.shared
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
