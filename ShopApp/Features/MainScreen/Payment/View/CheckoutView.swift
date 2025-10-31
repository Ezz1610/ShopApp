//
//  CheckoutView.swift
//  ShopApp
//
//  Created by Soha Elgaly on 31/10/2025.
//

import SwiftUI

struct CheckoutView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(CartManager.self) var cartManager
    @StateObject var vm = CheckoutViewModel()
  
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                   
                    orderSummarySection
                    
                    shippingInfoSection
                  
                    paymentMethodSection
                    
                    mockPaymentDetailsSection
                  
                    payButton
                }
                .padding()
            }
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .overlay {
                if vm.showPaymentProcessing {
                    paymentProcessingOverlay
                }
            }
            .alert("Payment Successful! 🎉", isPresented: $vm.showSuccessAlert) {
                Button("OK") {
                    cartManager.clearCart()
                    dismiss()
                }
            } message: {
                Text("Your order has been placed successfully!\nOrder Total: \(cartManager.displayTotalCartPrice)\n\nShipping to:\n\(vm.fullName)\n\(vm.address), \(vm.city), \(vm.state) \(vm.zipCode)")
            }
            .alert("Validation Error", isPresented: $vm.showValidationAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(vm.validationMessage)
            }
        }
    }
    
    // MARK: - Order Summary
    private var orderSummarySection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Order Summary")
                .font(.title2.bold())
            
            VStack(spacing: 10) {
                ForEach(cartManager.productsInCart) { item in
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
                    Text(cartManager.displayTotalCartPrice)
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
                    Text(cartManager.displayTotalCartPrice)
                        .font(.title3.bold())
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    // MARK: - Shipping Information Section
    private var shippingInfoSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Shipping Information")
                .font(.title2.bold())
            
            VStack(spacing: 15) {
                // Full Name
                VStack(alignment: .leading, spacing: 5) {
                    Text("Full Name *")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("John Doe", text: $vm.fullName)
                        .textFieldStyle(CustomTextFieldStyle())
                        .textContentType(.name)
                }
                
                // Email
                VStack(alignment: .leading, spacing: 5) {
                    Text("Email *")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("john@example.com", text: $vm.email)
                        .textFieldStyle(CustomTextFieldStyle())
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                // Phone Number
                VStack(alignment: .leading, spacing: 5) {
                    Text("Phone Number *")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("+20 (111) 123-4567", text: $vm.phoneNumber)
                        .textFieldStyle(CustomTextFieldStyle())
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                }
                
                // Address
                VStack(alignment: .leading, spacing: 5) {
                    Text("Street Address *")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("123 Main Street", text: $vm.address)
                        .textFieldStyle(CustomTextFieldStyle())
                        .textContentType(.streetAddressLine1)
                }
                
                // City and State
                HStack(spacing: 15) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("City *")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextField("New York", text: $vm.city)
                            .textFieldStyle(CustomTextFieldStyle())
                            .textContentType(.addressCity)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("State *")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextField("NY", text: $vm.state)
                            .textFieldStyle(CustomTextFieldStyle())
                            .textContentType(.addressState)
                    }
                }
                
                // Zip Code and Country
                HStack(spacing: 15) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Zip Code *")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextField("10001", text: $vm.zipCode)
                            .textFieldStyle(CustomTextFieldStyle())
                            .textContentType(.postalCode)
                            .keyboardType(.numberPad)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Country *")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextField("USA", text: $vm.country)
                            .textFieldStyle(CustomTextFieldStyle())
                            .textContentType(.countryName)
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
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
                        
                        Text(method.rawValue)
                            .font(.body)
                        
                        Spacer()
                        
                        if vm.selectedPayment == method {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                        } else {
                            Image(systemName: "circle")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(vm.selectedPayment == method ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    // MARK: - Mock Payment Details
    private var mockPaymentDetailsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Test Payment Info")
                .font(.title3.bold())
            
            VStack(alignment: .leading, spacing: 8) {
                Label("This is a TEST payment only", systemImage: "info.circle.fill")
                    .font(.caption)
                    .foregroundColor(.orange)
                
                Text("• No real money will be charged")
                Text("• Payment will be simulated")
                Text("• Order will be processed as test")
            }
            .font(.caption)
            .foregroundColor(.secondary)
            .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    // MARK: - Pay Button
    private var payButton: some View {
        Button {
            validateAndProcessPayment()
        } label: {
            HStack {
                Image(systemName: vm.selectedPayment.icon)
                Text("Pay \(cartManager.displayTotalCartPrice)")
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(12)
        }
        .padding(.top)
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
                
                Text("Processing Payment...")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("Please wait")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(40)
            .background(Color.gray.opacity(0.9))
            .cornerRadius(20)
        }
    }
    
    // MARK: - Validation
    private func validateAndProcessPayment() {
        // Validate all required fields
        if vm.fullName.trimmingCharacters(in: .whitespaces).isEmpty {
            vm.validationMessage = "Please enter your full name"
            vm.showValidationAlert = true
            return
        }
        
        if vm.email.trimmingCharacters(in: .whitespaces).isEmpty {
            vm.validationMessage = "Please enter your email address"
            vm.showValidationAlert = true
            return
        }
        
        if !isValidEmail(vm.email) {
            vm.validationMessage = "Please enter a valid email address"
            vm.showValidationAlert = true
            return
        }
        
        if vm.phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty {
            vm.validationMessage = "Please enter your phone number"
            vm.showValidationAlert = true
            return
        }
        
        if vm.address.trimmingCharacters(in: .whitespaces).isEmpty {
            vm.validationMessage = "Please enter your street address"
            vm.showValidationAlert = true
            return
        }
        
        if vm.city.trimmingCharacters(in: .whitespaces).isEmpty {
            vm.validationMessage = "Please enter your city"
            vm.showValidationAlert = true
            return
        }
        
        if vm.state.trimmingCharacters(in: .whitespaces).isEmpty {
            vm.validationMessage = "Please enter your state"
            vm.showValidationAlert = true
            return
        }
        
        if vm.zipCode.trimmingCharacters(in: .whitespaces).isEmpty {
            vm.validationMessage = "Please enter your zip code"
            vm.showValidationAlert = true
            return
        }
        
        if vm.country.trimmingCharacters(in: .whitespaces).isEmpty {
            vm.validationMessage = "Please enter your country"
            vm.showValidationAlert = true
            return
        }
        
       
        processPayment()
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // MARK: - Process Payment
    private func processPayment() {
        vm.showPaymentProcessing = true
        
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            vm.showPaymentProcessing = false
            vm.showSuccessAlert = true
        }
    }
}

// MARK: - Custom TextField Style
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
    }
}

#Preview {
    CheckoutView()
        .environment(CartManager())
}
