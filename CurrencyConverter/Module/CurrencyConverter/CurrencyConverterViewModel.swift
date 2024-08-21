//
//  CurrencyConverterViewModel.swift
//  CurrencyConverter
//
//  Created by Anbalagan D on 07/07/23.
//

import Foundation
import Combine

final class CurrencyConverterViewModel: ObservableObject, @unchecked Sendable {
    private(set) var backstoreCurrencies = [Currency]()
    @Published var currencies = [Currency]()
    @Published var amount: String = ""
    @Published var selectedCurrency: Currency?
    @Published var appState: AppState = .loading
    
    private let exchangeRepository: ExchangeRepository
    private var cancellable: AnyCancellable?
    
    init(
        exchangeRepository: ExchangeRepository = ExchangeRepositoryImp(
            remoteRepository: ExchangeRemoteRepositoryImp(),
            localRepository: ExchangeLocalRepositoryImp(),
            cacheExpirationDurationInSecond: Constants.thirtyMinitue
        )
    ) {
        self.exchangeRepository = exchangeRepository
        addObsevers()
    }
    
    private func addObsevers() {
        cancellable = $selectedCurrency
            .compactMap { $0 }
            .sink {[weak self] currency in
                AppSettings.userLastSelectionCurrency = currency.symbol
                self?.updateCurrencies(except: currency)
        }
    }
    
    private func updateCurrencies(except: Currency) {
        currencies = backstoreCurrencies.filter { $0 != except }
    }
    
    @MainActor
    func getCurrencyExchange() async {
        defer { appState = .completed }
        appState = .loading
        
        do {
            let result = try await exchangeRepository.getCurrencies()
            self.backstoreCurrencies = result
            
            if let userPreferedCurrencySymbol = AppSettings.userLastSelectionCurrency,
               let currency = self.backstoreCurrencies.first(where: { $0.symbol == userPreferedCurrencySymbol }) {
                
                selectedCurrency = currency
                self.updateCurrencies(except: currency)
                
            } else {
                if let firstCurrency = self.backstoreCurrencies.first {
                    AppSettings.userLastSelectionCurrency = firstCurrency.symbol
                    self.updateCurrencies(except: firstCurrency)
                }
            }
        } catch {
            print("Show correct error message to user")
        }
    }
    
    func getExchangeRate(of currencyRate: Double) -> Double {
        return 1 / currencyRate
    }
    
    func convertAmount(
        from current: Double,
        to convert: Double,
        multiplyBy: Double = 1.0
    ) -> Double {
        let exchangeRate = 1 / current
        return multiplyBy * exchangeRate * convert
    }
}
