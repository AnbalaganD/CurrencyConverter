//
//  ExchangeRepositoryMock.swift
//  CurrencyConverterTests
//
//  Created by Anbalagan D on 09/07/23.
//

import Foundation
@testable import CurrencyConverter

final class ExchangeRepositoryMock: ExchangeRepository {
    func getCurrencies() async throws -> [Currency] {
        let jsonDecoder = JSONDecoder()
        let data = NetworkStubHelper.shared.getExchangeCurrencyData()!
        let result = try! jsonDecoder.decode(CurrencyExchangeDTO.self, from: data)
        return result.toDomain()
    }
}
