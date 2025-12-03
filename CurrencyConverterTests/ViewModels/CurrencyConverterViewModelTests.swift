//
//  CurrencyConverterViewModelTests.swift
//  CurrencyConverterTests
//
//  Created by Anbalagan D on 09/07/23.
//

import Testing
@testable import CurrencyConverter

struct CurrencyConverterViewModelTests {
    @Test
    func currencyCorrectlyAssigned() async {
        let viewModel = CurrencyConverterViewModel(
            exchangeRepository: ExchangeRepositoryMock()
        )
        await viewModel.getCurrencyExchange()
        #expect(viewModel.backstoreCurrencies.count == 169, "Could not retrieve the Data correctly")
    }
    
    @Test
    func currencyExchangeRate() {
        let viewModel = CurrencyConverterViewModel(
            exchangeRepository: ExchangeRepositoryMock()
        )
        let exchangeRate = viewModel.getExchangeRate(of: 2.0)
        #expect(exchangeRate == 0.5, "Expected value is 0.5")
    }
    
    @Test
    func currencyExchangeRateDivideByZero() {
        let viewModel = CurrencyConverterViewModel(
            exchangeRepository: ExchangeRepositoryMock()
        )
        let exchangeRate = viewModel.getExchangeRate(of: 0.0)
        #expect(!exchangeRate.isNaN, "Expected value is NAN")
    }
    
    @Test
    func convertAmountCorrectly() {
        let viewModel = CurrencyConverterViewModel(
            exchangeRepository: ExchangeRepositoryMock()
        )
        let result = viewModel.convertAmount(from: 2.0, to: 4.0, multiplyBy: 6.0)
        #expect(result == 12.0)
    }
    
    @Test
    func currenciesCorrectlyUpdateWhileSelectionCurrencyChanged() async throws {
        let viewModel = CurrencyConverterViewModel(
            exchangeRepository: ExchangeRepositoryMock()
        )
        await viewModel.getCurrencyExchange()
        let randomSelectedCurrency = viewModel.backstoreCurrencies.randomElement()
        viewModel.selectedCurrency = randomSelectedCurrency
        
        #expect(randomSelectedCurrency != nil, "`backstoreCurrencies` is empty")
        
        let isContain = viewModel.currencies.contains { currency in
            currency.symbol == randomSelectedCurrency!.symbol
        }
        #expect(!isContain, "Selected Currency should not contain in `currencies` array")
    }
}
