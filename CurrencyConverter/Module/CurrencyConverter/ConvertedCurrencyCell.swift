//
//  ConvertedCurrencyCell.swift
//  CurrencyConverter
//
//  Created by Anbalagan D on 09/07/23.
//

import SwiftUI

struct ConvertedCurrencyCell: View {
    let currencySymbol: String
    let exchangeRate: Double
    let amount: Double
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Currency Symbol: ")
                        .foregroundColor(.gray)
                        .font(.system(size: 13))
                    +
                    Text(currencySymbol)
                        .foregroundColor(.primary)
                        .font(.system(size: 13, weight: .semibold))
                    
                    Text("Exchange Rate: ")
                        .foregroundColor(.gray)
                        .font(.system(size: 13))
                    +
                    Text("\(exchangeRate)")
                        .foregroundColor(.primary)
                        .font(.system(size: 13, weight: .semibold))
                }
                
                Spacer()
                Text("\(amount)")
            }
            .padding(.vertical, 10)
            
            Divider()
        }
    }
}
