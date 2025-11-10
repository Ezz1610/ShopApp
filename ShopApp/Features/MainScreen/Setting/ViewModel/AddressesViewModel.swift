//
//  AddressesViewModel.swift
//  ShopApp
//
//  Created by Soha Elgaly on 09/11/2025.
//

import Foundation
import SwiftData

class AddressesViewModel: ObservableObject {
    static let shared = AddressesViewModel()
    
    private var modelContext: ModelContext?
    @Published var defaultAddressId: UUID?
    
    private let defaultAddressKey = "default_address_id"
    
    private init() {
        loadDefaultAddressId()
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func refreshAddresses() {
        // Trigger UI refresh
        objectWillChange.send()
    }
    
    func setDefaultAddress(_ id: UUID) {
        defaultAddressId = id
        saveDefaultAddressId()
    }
    
    func deleteAddress(_ address: Address) {
        guard let context = modelContext else { return }
        
        context.delete(address)
        
        do {
            try context.save()
          
            if address.id == defaultAddressId {
                defaultAddressId = nil
                saveDefaultAddressId()
            }
        } catch {
            print("Error deleting address: \(error.localizedDescription)")
        }
    }
    
    func getDefaultAddress() -> Address? {
        guard let context = modelContext,
              let defaultId = defaultAddressId else { return nil }
        
        let descriptor = FetchDescriptor<Address>(
            predicate: #Predicate { $0.id == defaultId }
        )
        
        return try? context.fetch(descriptor).first
    }
    
    func getAllAddresses() -> [Address] {
        guard let context = modelContext else { return [] }
        
        let descriptor = FetchDescriptor<Address>()
        return (try? context.fetch(descriptor)) ?? []
    }
    
    // MARK: - Persistence (Only for default ID)
    private func saveDefaultAddressId() {
        if let id = defaultAddressId {
            UserDefaults.standard.set(id.uuidString, forKey: defaultAddressKey)
        } else {
            UserDefaults.standard.removeObject(forKey: defaultAddressKey)
        }
    }
    
    private func loadDefaultAddressId() {
        if let idString = UserDefaults.standard.string(forKey: defaultAddressKey),
           let uuid = UUID(uuidString: idString) {
            defaultAddressId = uuid
        }
    }
}
