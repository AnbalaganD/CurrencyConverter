//
//  PreInterceptor.swift
//  CurrencyConverter
//
//  Created by Anbalagan D on 06/07/23.
//

import Foundation

protocol PreInterceptor {
    func modify(request: URLRequest) async -> URLRequest
}

final class AuthenticationInterceptor: PreInterceptor {
    func modify(request: URLRequest) async -> URLRequest {
        var modifiedURLRequest = request
        modifiedURLRequest.setValue(
            "Token \(Config.openExchangeRatesAppId)",
            forHTTPHeaderField: "Authorization"
        )
        return modifiedURLRequest
    }
}
