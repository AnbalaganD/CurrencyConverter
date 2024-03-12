//
//  ConnectivityCheckerMock.swift
//  CurrencyConverterTests
//
//  Created by Anbalagan D on 10/07/23.
//

@testable import CurrencyConverter
import Combine

final class ConnectivityCheckerMock: ConnectivityChecker, @unchecked Sendable {
    var _connectivityPublisher = PassthroughSubject<Bool, Never>()
    var connectivityPublisher: AnyPublisher<Bool, Never> {
        _connectivityPublisher.eraseToAnyPublisher()
    }
    
    private(set) var isConnected: Bool
    
    init(isConnected: Bool) {
        self.isConnected = isConnected
        _connectivityPublisher.send(isConnected)
    }
}
