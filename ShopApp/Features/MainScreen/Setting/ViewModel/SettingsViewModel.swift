//
//  SettingsViewModel.swift
//  ShopApp
//
//  Created by Soha Elgaly on 23/10/2025.
//


import SwiftUI
import Combine

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var username = "Soha Elgaly"
    @Published var email = "soha@example.com"
    @Published var location = " Unknown "
    @Published var selectedCurrency = "EGP"
    @Published var isDarkMode = false

    let currencies = ["USD","EGP", "EUR", "SAR"]
        private var cancellables = Set<AnyCancellable>()
        private let locationManager = LocationManager.shared
        
        init() {
            locationManager.$currentCity
                .receive(on: RunLoop.main)
                .sink { [weak self] city in
                    if !city.isEmpty {
                        self?.location = city
                    }
                }
                .store(in: &cancellables)
        }
        
        func requestUserLocation() {
            locationManager.requestLocationPermission()
        }
        
    func toggleTheme() {
        isDarkMode.toggle()
    }
    
   
}

