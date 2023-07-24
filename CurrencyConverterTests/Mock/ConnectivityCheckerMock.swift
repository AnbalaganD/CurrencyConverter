//
//  ConnectivityCheckerMock.swift
//  CurrencyConverterTests
//
//  Created by Anbalagan D on 10/07/23.
//

@testable import CurrencyConverter

final class ConnectivityCheckerMock: ConnectivityChecker {
    private(set) var isConnected: Bool
    
    init(isConnected: Bool) {
        self.isConnected = isConnected
    }
}
