//
//  PaymentModel.swift
//  ShopApp
//
//  Created by Soha Elgaly on 31/10/2025.
//

import Foundation
import SwiftUI

class CheckoutViewModel: ObservableObject {
    
    // Shipping Information
    @Published var fullName = ""
    @Published var email = ""
    @Published var phoneNumber = ""
    @Published var address = ""
    @Published var city = ""
    @Published var state = ""
    @Published var zipCode = ""
    @Published var country = ""
    
    // Payment
    @Published var selectedPayment: PaymentMethod = .paypal
    @Published var showPaymentProcessing = false
    @Published var paymentSuccess = false
    @Published var showSuccessAlert = false
    @Published var showValidationAlert = false
    @Published var validationMessage = ""
    
    enum PaymentMethod: String, CaseIterable {
        case paypal = "PayPal"
        case creditCard = "Credit Card"
        case applePay = "Apple Pay"
        
        var icon: String {
            switch self {
            case .paypal: return "dollarsign.circle.fill"
            case .creditCard: return "creditcard.fill"
            case .applePay: return "apple.logo"
            }
        }
    }
}
