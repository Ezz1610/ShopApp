//
//  CurrencyManager.swift
//  ShopApp
//
//  Created by Soha Elgaly on 09/11/2025.
//

import Foundation
import SwiftUI

@Observable
class CurrencyManager {
    static let shared = CurrencyManager()
    
    var selectedCurrency: String = "USD"
    var exchangeRate: Double = 1.0
    
    func updateCurrency(to currency: String) {
        selectedCurrency = currency
        fetchExchangeRate(for: currency)
    }
    
    private func fetchExchangeRate(for currency: String) {
        switch currency {
        case "EUR":
            exchangeRate = 0.93
        case "EGP":
            exchangeRate = 49.5
        case "SAR":
            exchangeRate = 3.75
        default:
            exchangeRate = 1.0
        }
    }
}
