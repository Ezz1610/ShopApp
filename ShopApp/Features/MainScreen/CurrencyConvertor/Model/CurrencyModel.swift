//
//  CurrencyModel.swift
//  ShopApp
//
//  Created by Soha Elgaly on 09/11/2025.
//

import Foundation

struct ExchangeRateAPIResponse: Codable {
    let rates: [String: Double]
    let base: String
    let date: String
}

struct CurrencyData: Codable {
    let code: String
    let value: Double
}
