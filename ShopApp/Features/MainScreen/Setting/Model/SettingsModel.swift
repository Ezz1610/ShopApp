//
//  SettingsModel.swift
//  ShopApp
//
//  Created by Soha Elgaly on 23/10/2025.
//

import Foundation


struct Address: Identifiable {
    let id = UUID()
    let name: String
    let street: String
    let city: String
    let state: String
    let zipCode: String
    let country: String
    let phone: String?
}
