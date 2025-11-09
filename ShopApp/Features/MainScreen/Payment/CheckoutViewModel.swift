//
//  CheckoutViewModel.swift
//  ShopApp
//
//  Created by Soha Elgaly on 08/11/2025.
//


import Foundation
import SwiftUI

class CheckoutViewModel: ObservableObject {
    
    // Payment
    @Published var selectedPayment: PaymentMethod = .cashOnDelivery
    @Published var showPaymentProcessing = false
    @Published var paymentSuccess = false
    @Published var showSuccessAlert = false
    @Published var paymentMessage = ""
    @Published var showPayPalSheet = false
    
    enum PaymentMethod: String, CaseIterable {
        case cashOnDelivery = "Cash on Delivery"
        case paypal = "PayPal"
        
        var icon: String {
            switch self {
            case .cashOnDelivery: return "banknote.fill"
            case .paypal: return "dollarsign.circle.fill"
            }
        }
    }
}

