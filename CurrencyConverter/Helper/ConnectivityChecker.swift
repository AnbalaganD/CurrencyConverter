//
//  ConnectivityChecker.swift
//  CurrencyConverter
//
//  Created by Anbalagan D on 10/07/23.
//

import Network
import Combine

protocol ConnectivityChecker: Sendable {
    var isConnected: Bool { get }
    var connectivityPublisher: AnyPublisher<Bool, Never> { get }
}

final class ConnectivityCheckerImp: ConnectivityChecker, @unchecked Sendable {
    private let _connectivityPublisher: PassthroughSubject<Bool, Never> = PassthroughSubject()
    var connectivityPublisher: AnyPublisher<Bool, Never> {
        _connectivityPublisher.eraseToAnyPublisher()
    }
    
    private(set) var isConnected: Bool = false
    
    private let monitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "com.currency_converter.path_monitor")
    
    static let shared = ConnectivityCheckerImp()
    
    private init() {
        addPathHandler()
    }
    
    private func addPathHandler() {
        monitor.pathUpdateHandler = {[weak self] path in
            guard let self else { return }
            let connected = path.status == .satisfied
            if isConnected != connected {
                isConnected = connected
                _connectivityPublisher.send(connected)
            }
        }
        monitor.start(queue: monitorQueue)
    }
}
