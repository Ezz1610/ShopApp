//
//  CheckoutView.swift
//  ShopApp
//
//  Created by Soha Elgaly on 08/11/2025.
//

import SwiftUI
import BraintreeCore
import BraintreePayPal
import BraintreePayPalNativeCheckout
struct CheckoutView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm = CheckoutViewModel()
    let braintreeTokenizationKey = "sandbox_sh55mkdq_876zjrvwhbwqnjxj"
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    orderSummarySection
                    //testModeNotice
                    paymentMethodSection
                    payButton
                }
                .padding()
            }
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar
            { ToolbarItem(placement: .navigationBarLeading)
                { Button("Cancel")
                    { dismiss()
                    } }
            } .overlay {
                if vm.showPaymentProcessing {
                    paymentProcessingOverlay
                }
            } .alert("Order Placed! 🎉", isPresented: $vm.showSuccessAlert) {
                Button("OK") {
                    CartManager.shared.clearCart()
                    dismiss()
                }
                } message: {
                    Text(vm.paymentMessage)
            }
        }
    }
    // MARK: - Order Summary
    private var orderSummarySection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Order Summary")
                .font(.title2.bold())
            VStack(spacing: 20) {
                ForEach(CartManager.shared.productsInCart) { item in
                    HStack {
                        Text("\(item.product.title) x\(item.quantity)")
                            .font(.body)
                        Spacer()
                        Text("$\((Double(item.product.variants.first?.price ?? "0") ?? 0) * Double(item.quantity), specifier: "%.2f")")
                            .font(.body.bold())
                    }
                }
                Divider()
                HStack {
                    Text("Subtotal")
                        .font(.body)
                    Spacer()
                    Text(CartManager.shared.displayTotalCartPrice)
                        .font(.body)
                }
                HStack {
                    Text("Shipping")
                        .font(.body)
                    Spacer()
                    Text("Free")
                        .font(.body)
                        .foregroundColor(.green)
                }
                Divider()
                HStack {
                    Text("Total")
                        .font(.title3.bold())
                    Spacer()
                    Text(CartManager.shared.displayTotalCartPrice)
                        .font(.title3.bold())
                        .foregroundColor(.blue)
                }
            } .padding() .background(Color.gray.opacity(0.1)) .cornerRadius(12) } }
    // MARK: - Payment Method Selection
    private var paymentMethodSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Payment Method")
                .font(.title2.bold())
            ForEach(CheckoutViewModel.PaymentMethod.allCases, id: \.self) { method in
                Button {
                    vm.selectedPayment = method
                } label: {
                    HStack {
                        Image(systemName: method.icon)
                            .font(.title2)
                            .frame(width: 30)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(method.rawValue)
                                .font(.body.bold())
                            if method == .cashOnDelivery {
                                Text("Pay when you receive")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Pay securely with PayPal")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        Spacer()
                        if vm.selectedPayment == method {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title3)
                        } else {
                            Image(systemName: "circle")
                                .foregroundColor(.gray)
                                .font(.title3)
                        }
                    } .padding()
                        .background(vm.selectedPayment == method ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1)) .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    // MARK: - Test Mode Notice
    private var testModeNotice: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.orange)
                Text("Pay Attension!")
                    .font(.headline)
                    .foregroundColor(.orange)
            }
            VStack(alignment: .leading, spacing: 8) {
                Text("• Refund or exchange available for only 7 days from delivery date!")
                Text("• Make sure your information is correct for fast delivery")
                if vm.selectedPayment == .paypal {
                    Text("• Use PayPal sandbox account to test")
                }
            }.font(.caption)
                .foregroundColor(.secondary)
        } .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(12)
    }
    // MARK: - Pay Button
    private var payButton: some View {
        Button {
            processPayment()
        } label: {
            HStack {
                Image(systemName: vm.selectedPayment.icon)
                if vm.selectedPayment == .cashOnDelivery {
                    Text("Place Order (\(CartManager.shared.displayTotalCartPrice))")
                } else {
                    Text("Pay with PayPal (\(CartManager.shared.displayTotalCartPrice))")
                }
            } .font(.headline)
                .foregroundColor(.white)
                .frame(height: 30)
                .frame(maxWidth: .infinity)
                .padding()
                .background(vm.selectedPayment == .cashOnDelivery ? AppColors.primary : AppColors.black) .cornerRadius(12)
        } .padding(.top)
    }
    // MARK: - Payment Processing Overlay
    private var paymentProcessingOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            VStack(spacing: 20) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)
                Text(vm.selectedPayment == .paypal ? "Opening PayPal..." : "Processing Order...") .font(.headline)
                    .foregroundColor(.white)
                Text("Please wait")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            } .padding(40)
                .background(Color.gray.opacity(0.9))
                .cornerRadius(20)
        }
    }
    // MARK: - Process Payment private
    func processPayment() {
        if vm.selectedPayment == .cashOnDelivery {
            processCashOnDelivery()
        } else {
            processPayPalPayment()
        }
    }
    private func processCashOnDelivery() {
        vm.showPaymentProcessing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5)
        {
            vm.showPaymentProcessing = false
            vm.paymentMessage = "Your order has been placed successfully!\n\nOrder Total: \(CartManager.shared.displayTotalCartPrice)\n\nPayment Method: Cash on Delivery\n\nYou will pay when you receive your order."
            vm.showSuccessAlert = true
        }
    }
    private func processPayPalPayment() {
        vm.showPaymentProcessing = true
        guard let braintreeClient = BTAPIClient(authorization: braintreeTokenizationKey) else {
            vm.showPaymentProcessing = false
            vm.paymentMessage = "Failed to initialize Braintree client. Check your token."
            vm.showSuccessAlert = true
            return
        }
        let payPalClient = BTPayPalNativeCheckoutClient(apiClient: braintreeClient)
        
        let numericAmount = CartManager.shared.displayTotalCartPrice
        
        .replacingOccurrences(of: "$", with: "")
        .trimmingCharacters(in: .whitespaces)
        
        let request = BTPayPalNativeCheckoutRequest(amount: numericAmount)
        request.currencyCode = "EGP"
        request.intent = .authorize
        
        payPalClient.tokenize(request) {result,error in
            DispatchQueue.main.async {
                vm.showPaymentProcessing = false
                if let error = error {
                    vm.paymentMessage = "Payment failed: \(error.localizedDescription)"
                    vm.showSuccessAlert = true
                    return
                }
                guard let result = result
                else {
                    vm.paymentMessage = "Payment cancelled."
                    vm.showSuccessAlert = true
                    return
                }
                print("✅ Nonce: \(result.nonce)")
                print("✅ Email: \(result.email ?? "N/A")")
                print("✅ Payer ID: \(result.clientMetadataID ?? "N/A")")
                vm.paymentMessage = """
                  Payment Successful!
                  🎉 Total: \(CartManager.shared.displayTotalCartPrice) 
                  Email: \(result.email ?? "Unknown")
                  Nonce: \(result.nonce)
                  """
                vm.showSuccessAlert = true
            }
        }
    }
}
#Preview {
    CheckoutView()
}
