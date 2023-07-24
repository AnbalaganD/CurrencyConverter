//
//  CurrencyConverterScreen.swift
//  CurrencyConverter
//
//  Created by Anbalagan D on 07/07/23.
//

import SwiftUI

struct CurrencyConverterScreen: View {
    @StateObject private var viewModel = CurrencyConverterViewModel()
    
    var body: some View {
            ScrollView {
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    Section(header: topInputView) {
                        if viewModel.appState == .loading {
                            ProgressView()
                                .progressViewStyle(.circular)
                        } else if viewModel.currencies.isEmpty {
                            Text("The requested data is currently unavailable or not accessible.\n\nMake sure you have stable internet connection")
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.top, 50)
                                
                        } else {
                            VStack(spacing: 0) {
                                ForEach(viewModel.currencies, id: \.self) { currency in
                                    ConvertedCurrencyCell(
                                        currencySymbol: currency.symbol,
                                        exchageRate: viewModel.getExchageRate(of: currency.rate),
                                        amount: viewModel.convertAmount(
                                            from: viewModel.selectedCurrency?.rate ?? 1.0,
                                            to: currency.rate,
                                            multiplyBy: Double(viewModel.amount) ?? 0.0
                                        )
                                    )
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .onAppear {
                UIScrollView.appearance().keyboardDismissMode = .interactive
                Task {
                    await viewModel.getCurrencyExchange()
                }
            }
            .navigationTitle("Currency Converter")
    }
    
    private var topInputView: some View {
        HStack {
            TextField("Enter Amount", text: $viewModel.amount)
                .keyboardType(.numberPad)
            
            Picker("", selection: $viewModel.selectedCurrency) {
                ForEach(viewModel.backstoreCurrencies, id: \.self) { currency in
                    Text(currency.symbol)
                        .tag(Optional(currency))
                }
            }
            .labelsHidden()
        }
        .padding(.horizontal, 8)
        .frame(height: 40)
        .overlay(
            RoundedRectangle(cornerRadius: 3)
                .stroke(.gray.opacity(0.5), lineWidth: 1)
        )
        .padding(.top, 10)
        .background(Color(UIColor.systemBackground))
    }
}
