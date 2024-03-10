//
//  PreInterceptor.swift
//  CurrencyConverter
//
//  Created by Anbalagan D on 06/07/23.
//

import Foundation

protocol PreInterceptor: Sendable {
    func modify(request: URLRequest) async throws -> URLRequest
}

final class AuthenticationInterceptor: PreInterceptor {
    func modify(request: URLRequest) async throws -> URLRequest {
        var modifiedURLRequest = request
        modifiedURLRequest.setValue(
            "Token \(Config.openExchangeRatesAppId)",
            forHTTPHeaderField: "Authorization"
        )
        return modifiedURLRequest
    }
}
