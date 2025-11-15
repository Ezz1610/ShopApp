////
////  SettingsModel.swift
////  ShopApp
////
////  Created by Soha Elgaly on 23/10/2025.
////
//
import SwiftUI
import SwiftData


@Model
final class Address {
    @Attribute(.unique) var id: UUID
    var name: String
    var street: String
    var city: String
    var state: String
    var zipCode: String
    var country: String
    var phone: String?
    var isDefault: Bool = false
    
    init(id: UUID = UUID(), name: String, street: String, city: String, state: String, zipCode: String, country: String, phone: String?, isDefault: Bool = false) {
        self.id = id
        self.name = name
        self.street = street
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.country = country
        self.phone = phone
        self.isDefault = isDefault
    }
}
enum AddressSourceView {
    case settings
    case checkout
}
