//
//  ConnectivityChecker.swift
//  CurrencyConverter
//
//  Created by Anbalagan D on 10/07/23.
//

import Network

protocol ConnectivityChecker {
    var isConnected: Bool { get }
}

final class ConnectivityCheckerImp: ConnectivityChecker {
    private(set) var isConnected: Bool = false
    
    private let monitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "com.currency_converter.path_monitor")
    
    static let shared = ConnectivityCheckerImp()
    
    private init() {
        addPathHandler()
    }
    
    private func addPathHandler() {
        monitor.pathUpdateHandler = {[weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: monitorQueue)
    }
}
