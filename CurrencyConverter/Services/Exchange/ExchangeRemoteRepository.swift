//
//  ExchangeRemoteRepository.swift
//  CurrencyConverter
//
//  Created by Anbalagan D on 09/07/23.
//

protocol ExchangeRemoteRepository: Sendable {
    func getCurrencies() async throws -> [Currency]
}

final class ExchangeRemoteRepositoryImp: ExchangeRemoteRepository {
    private let remoteService: any RemoteService
    init(remoteService: any RemoteService = Remote.sharedRemoteService) {
        self.remoteService = remoteService
    }

    func getCurrencies() async throws -> [Currency] {
        let result: CurrencyExchangeDTO = try await remoteService.execute(
            request: .init(
                url: EndPoints.baseUrl + EndPoints.latestCurrencyExchangeAPI
            )
        )
        return result.toDomain()
    }
}
