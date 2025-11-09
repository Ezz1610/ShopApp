//
//  CheckoutViewModel.swift
//  ShopApp
//
//  Created by Soha Elgaly on 08/11/2025.
//


import Foundation
import SwiftUI
import PayPalCheckout
class CheckoutViewModel: ObservableObject {
    @Published var selectedPayment: PaymentMethod = .paypal
    @Published var showPaymentProcessing = false
    @Published var showSuccessAlert = false
    @Published var paymentMessage = ""
    
    enum PaymentMethod: String, CaseIterable {
        case paypal = "PayPal"
        case cashOnDelivery = "Cash on Delivery"
        
        var icon: String {
            switch self {
            case .paypal: return "creditcard.fill"
            case .cashOnDelivery: return "banknote.fill"
            }
        }
    }
    
    func configurePayPalCheckout() {
            // Configure checkout with your Client ID
            let config = CheckoutConfig(
                clientID: "AV5xikO7QmmMqSzB3_Pbimcdknd9IZSUgEM2Ow13d5kzFIgqIIuvfSMGKqU2Yg7pD3H5g6D_pIdC-3Q_",
                returnUrl: "shopapp://paypalpay",
                environment: PayPalCheckout.Environment.sandbox
            )
            
            Checkout.set(config: config)
            
            // Set up create order callback
            Checkout.setCreateOrderCallback { [weak self] createOrderAction in
                guard let self = self else { return }
                
                let baseTotal = CartManager.shared.totalCartValueInUSD
                let convertedTotal = baseTotal * CurrencyManager.shared.exchangeRate
                let amount = String(format: "%.2f", convertedTotal)
                
                // Create the purchase amount
                let purchaseAmount = PurchaseUnit.Amount(
                    currencyCode: self.getCurrencyCode(),
                    value: amount
                )
                
                // Create purchase unit
                let purchaseUnit = PurchaseUnit(amount: purchaseAmount)
                
                // Create order request
                let order = OrderRequest(
                    intent: .capture,
                    purchaseUnits: [purchaseUnit]
                )
                
                // Create the order
                createOrderAction.create(order: order)
            }
            
            // Set up approval callback
            Checkout.setOnApproveCallback { [weak self] approval in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.showPaymentProcessing = false
                    
                    let baseTotal = CartManager.shared.totalCartValueInUSD
                    let convertedTotal = baseTotal * CurrencyManager.shared.exchangeRate
                    let displayTotal = "\(String(format: "%.2f", convertedTotal)) \(CurrencyManager.shared.selectedCurrency)"
                    
                    // Capture the order
                    approval.actions.capture { response, error in
                        if let error = error {
                            self.paymentMessage = "Payment failed: \(error.localizedDescription)"
                            print(error)
                            self.showSuccessAlert = true
                            return
                        }
                        
                        guard let response = response else {
                            self.paymentMessage = "Payment failed: No response"
                            self.showSuccessAlert = true
                            return
                        }
                        
                        self.paymentMessage = """
                        Payment Successful! 🎉
                        Total: \(displayTotal)
                        Your order has been confirmed!
                        Go Check your inbox for more info 📩
                        """
                        self.showSuccessAlert = true
                        
                        print("✅ Order captured successfully, Check your mail")
                       
                    }
                }
            }
            
            // Set up cancel callback
            Checkout.setOnCancelCallback { [weak self] in
                DispatchQueue.main.async {
                    self?.showPaymentProcessing = false
                    self?.paymentMessage = "Payment cancelled."
                    self?.showSuccessAlert = true
                }
            }
            
            // Set up error callback
            Checkout.setOnErrorCallback { [weak self] error in
                DispatchQueue.main.async {
                    self?.showPaymentProcessing = false
                    self?.paymentMessage = "Payment failed: \(error.reason)"
                    self?.showSuccessAlert = true
                }
            }
        Checkout.setOnShippingChangeCallback { shippingChange, shippingChangeAction in
                    // Always approve shipping changes for now
                    shippingChangeAction.approve()
                }
        }
  
        
        private func getCurrencyCode() -> CurrencyCode {
            switch CurrencyManager.shared.selectedCurrency {
            case "USD": return .usd
            case "EUR": return .eur
            case "GBP": return .gbp
            case "CAD": return .cad
            case "AUD": return .aud
            case "JPY": return .jpy
            default: return .usd
            }
        }
    }



