//
//  ConnectivityChecker.swift
//  CurrencyConverter
//
//  Created by Anbalagan D on 10/07/23.
//

import Network
import Combine

protocol ConnectivityChecker {
    var isConnected: Bool { get }
    var connectivityPublisher: AnyPublisher<Bool, Never> { get }
}

final class ConnectivityCheckerImp: ConnectivityChecker {
    private let _connectivityPublisher: PassthroughSubject<Bool, Never> = PassthroughSubject()
    var connectivityPublisher: AnyPublisher<Bool, Never> {
        return _connectivityPublisher.eraseToAnyPublisher()
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
