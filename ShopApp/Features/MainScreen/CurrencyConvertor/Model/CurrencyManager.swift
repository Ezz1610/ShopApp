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
    var isLoading: Bool = false
    var lastUpdateTime: Date?
    var errorMessage: String?
    
   
    let supportedCurrencies = ["USD", "EUR", "GBP", "EGP", "SAR", "AED", "AUD", "CAD", "JPY"]
    
    let currencySymbols: [String: String] = [
        "USD": "$",
        "EUR": "€",
        "GBP": "£",
        "EGP": "E£",
        "SAR": "﷼",
        "AED": "د.إ",
        "AUD": "A$",
        "CAD": "C$",
        "JPY": "¥"
    ]
    
    

    
    func updateCurrency(to currency: String) {
        selectedCurrency = currency
        fetchExchangeRate(for: currency)
    }
    
    func refreshRates() {
        fetchExchangeRate(for: selectedCurrency)
    }
    
    func getCurrencySymbol() -> String {
        return currencySymbols[selectedCurrency] ?? selectedCurrency
    }
    
    func formatPrice(_ priceInUSD: Double) -> String {
        let convertedPrice = priceInUSD * exchangeRate
        let symbol = getCurrencySymbol()
        
       
        if selectedCurrency == "JPY" {
           
            return "\(symbol)\(Int(convertedPrice))"
        } else {
            return "\(symbol)\(String(format: "%.2f", convertedPrice))"
        }
    }
    
    private func fetchExchangeRate(for currency: String) {
        
        guard currency != "USD" else {
            exchangeRate = 1.0
            return
        }
        
        isLoading = true
        errorMessage = nil

        fetchFromExchangeRateAPI(for: currency)
        
    }

    private func fetchFromExchangeRateAPI(for currency: String) {
        let urlString = "https://api.exchangerate-api.com/v4/latest/USD"
        
        guard let url = URL(string: urlString) else {
            handleError("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.handleError(error.localizedDescription)
                    return
                }
                
                guard let data = data else {
                    self?.handleError("No data received")
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(ExchangeRateAPIResponse.self, from: data)
                    
                    if let rate = result.rates[currency] {
                        self?.exchangeRate = rate
                        self?.lastUpdateTime = Date()
                        print("✅ Exchange rate updated: 1 USD = \(rate) \(currency)")
                    } else {
                        self?.handleError("Currency not found")
                    }
                } catch {
                    self?.handleError("Failed to parse data: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    private func handleError(_ message: String) {
        errorMessage = message
        print("❌ Currency error: \(message)")
        
        useFallbackRates()
    }
    
    private func useFallbackRates() {
        switch selectedCurrency {
        case "EUR":
            exchangeRate = 0.93
        case "GBP":
            exchangeRate = 0.79
        case "EGP":
            exchangeRate = 49.5
        case "SAR":
            exchangeRate = 3.75
        case "AED":
            exchangeRate = 3.67
        case "AUD":
            exchangeRate = 1.48
        case "CAD":
            exchangeRate = 1.35
        case "JPY":
            exchangeRate = 149.0
        default:
            exchangeRate = 1.0
        }
    }
}



