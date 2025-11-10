//
//  CurrencyTestView.swift
//  ShopApp
//
//  Created by Soha Elgaly on 09/11/2025.
//

import SwiftUI

struct CurrencySettingsView: View {
    @Bindable var currencyManager = CurrencyManager.shared
    
    var body: some View {
        List {
            Section {
                ForEach(currencyManager.supportedCurrencies, id: \.self) { currency in
                    Button {
                        currencyManager.updateCurrency(to: currency)
                    } label: {
                        HStack {
                            Text(currencyManager.currencySymbols[currency] ?? "")
                                .font(.title2)
                                .frame(width: 40)
                            
                            Text(currency)
                                .font(.body)
                            
                            Spacer()
                            
                            if currencyManager.selectedCurrency == currency {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .foregroundColor(.primary)
                }
            } header: {
                Text("Select Currency")
            } footer: {
                if let lastUpdate = currencyManager.lastUpdateTime {
                    Text("Last updated: \(lastUpdate.formatted())")
                        .font(.caption)
                }
                
                if let error = currencyManager.errorMessage {
                    Text("⚠️ \(error) - Using fallback rates")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
            
            Section {
                HStack {
                    Text("Current Rate")
                    Spacer()
                    if currencyManager.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else {
                        Text("1 USD = \(String(format: "%.4f", currencyManager.exchangeRate)) \(currencyManager.selectedCurrency)")
                            .foregroundColor(.secondary)
                    }
                }
                
                Button {
                    currencyManager.refreshRates()
                } label: {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Refresh Rates")
                    }
                }
                .disabled(currencyManager.isLoading)
            } header: {
                Text("Exchange Rate")
            }
        }
        .navigationTitle("Currency Settings")
    }
}

#Preview {
    NavigationStack {
        CurrencySettingsView()
    }
}
