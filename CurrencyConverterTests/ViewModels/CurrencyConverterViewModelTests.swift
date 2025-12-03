//
//  CurrencyConverterViewModelTests.swift
//  CurrencyConverterTests
//
//  Created by Anbalagan D on 09/07/23.
//

import XCTest
@testable import CurrencyConverter

final class CurrencyConverterViewModelTests: XCTestCase {
    
    private var viewModel: CurrencyConverterViewModel!
    
    override func setUpWithError() throws {
        viewModel = CurrencyConverterViewModel(
            exchangeRepository: ExchangeRepositoryMock()
        )
    }
    
    func testCurrencyCorrectlyAssigned() async {
        await viewModel.getCurrencyExchange()
        XCTAssertTrue(viewModel.backstoreCurrencies.count == 169, "Could not retrieve the Data correctly")
    }
    
    func testCurrencyExchangeRate() {
        let exchangeRate = viewModel.getExchangeRate(of: 2.0)
        XCTAssertTrue(exchangeRate == 0.5, "Expected value is 0.5")
    }
    
    func testCurrencyExchangeRateDivideByZero() {
        let exchangeRate = viewModel.getExchangeRate(of: 0.0)
        XCTAssertFalse(exchangeRate.isNaN, "Expected value is NAN")
    }
    
    func testConvertAmountCorrectly() {
        let result = viewModel.convertAmount(from: 2.0, to: 4.0, multiplyBy: 6.0)
        XCTAssertTrue(result == 12.0)
    }
    
    func testCurrenciesCorrectlyUpdateWhileSelectionCurrencyChanged() async throws {
        await viewModel.getCurrencyExchange()
        let randomSelectedCurrency = viewModel.backstoreCurrencies.randomElement()
        viewModel.selectedCurrency = randomSelectedCurrency
        
        XCTAssertNotNil(randomSelectedCurrency, "`backstoreCurrencies` is empty")
        
        let isContain = viewModel.currencies.contains { currency in
            currency.symbol == randomSelectedCurrency!.symbol
        }
        XCTAssertFalse(isContain, "Selected Currency should not contain in `currencies` array")
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
    }
}
