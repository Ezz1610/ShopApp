//
//  SettingsViewModel.swift
//  ShopApp
//
//  Created by Soha Elgaly on 23/10/2025.
//
import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    @Published var username = "John Doe"
    @Published var email = "john.doe@example.com"
    @Published var location = ""
    @Published var isDarkMode = false
    @Published var defaultAddress: String?
    
    func requestUserLocation() {
  
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.location = "New York, USA"
        }
    }
    
    func logout() {
        print("User logged out")
    }
}




