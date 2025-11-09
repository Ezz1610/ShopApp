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


import UIKit


class AddressesViewModel: ObservableObject {
    @Published var addresses: [Address] = []
    @Published var defaultAddressId: UUID?
    
    func addAddress(_ address: Address, setAsDefault: Bool) {
        addresses.append(address)
        if setAsDefault || addresses.count == 1 {
            defaultAddressId = address.id
        }
    }
    
    func setDefaultAddress(_ id: UUID) {
        defaultAddressId = id
    }
    
    func deleteAddress(at offsets: IndexSet) {
        addresses.remove(atOffsets: offsets)
        if let firstId = offsets.first, addresses[firstId].id == defaultAddressId {
            defaultAddressId = addresses.first?.id
        }
    }
    
    func getDefaultAddress() -> Address? {
        addresses.first { $0.id == defaultAddressId }
    }
}
