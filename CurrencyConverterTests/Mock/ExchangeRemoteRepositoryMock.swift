//
//  ExchangeRemoteRepositoryMock.swift
//  CurrencyConverterTests
//
//  Created by Anbalagan D on 10/07/23.
//

import Foundation
@testable import CurrencyConverter

final class ExchangeRemoteRepositoryMock: ExchangeRemoteRepository {
    func getCurrencies() async throws -> [Currency] {
        throw RemoteError.general(status: "Not Implemented", statusCode: 501)
    }
}
