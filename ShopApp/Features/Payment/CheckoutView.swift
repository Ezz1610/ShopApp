//
//  CheckoutView.swift
//  ShopApp
//
//  Created by Soha Elgaly on 08/11/2025.
//






import SwiftUI
import PayPalCheckout
import SwiftData
import FirebaseAuth
// MARK: - Checkout View
struct CheckoutView: View {
    @SwiftUI.Environment(\.dismiss) var dismiss
    @StateObject var vm = CheckoutViewModel()
    @Bindable var currencyManager = CurrencyManager.shared
    @SwiftUI.Environment(\.modelContext) private var modelContext
    @Query private var addresses: [Address]
    @AppStorage("defaultAddressID") private var defaultAddressID: String?
    @EnvironmentObject var navigator: AppNavigator
    @SwiftUI.State private var couponCode = ""
    @SwiftUI.State private var appliedCoupon: AppliedCoupon?
    @SwiftUI.State private var showCouponError = false
    @SwiftUI.State private var couponErrorMessage = ""
    private var defaultAddress: Address? {
        if let id = defaultAddressID, let uuid = UUID(uuidString: id) {
            return addresses.first { $0.id == uuid }
        }
        return addresses.first
    }
    @SwiftUI.State private var showAddAddress = false
    @ObservedObject var viewModel = AddressesViewModel.shared
    var body: some View {
        NavigationStack {
        ScrollView {
            VStack(spacing: 25) {
                shippingAddressSection
                couponSection
                orderSummarySection
                testModeNotice
                paymentMethodSection
                payButton
            }
            .padding()
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                
                    navigator.goTo(.cartView, replaceLast: false)
                    dismiss()
                }
            }
        }
        .overlay {
            if vm.showPaymentProcessing {
                paymentProcessingOverlay
            }
        }
        .alert("Order Placed! 🎉", isPresented: $vm.showSuccessAlert) {
            Button("View Orders") {
                CartManager.shared.clearCart()
                appliedCoupon = nil
                navigator.goTo(.ordersView, replaceLast: false)
                dismiss()
            }
            Button("Done") {
                CartManager.shared.clearCart()
                appliedCoupon = nil
                dismiss()
            }
        } message: {
            Text(vm.paymentMessage)
        }
        .alert("Invalid Coupon", isPresented: $showCouponError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(couponErrorMessage)
        }
        .onAppear {
            vm.configurePayPalCheckout()
        }
        
    }
    }
    
    // MARK: - Coupon Section
    private var couponSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Promo Code")
                .font(.title2.bold())
            
            if let appliedCoupon = appliedCoupon {
                HStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.1))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "checkmark.seal.fill")
                            .font(.title3)
                            .foregroundColor(.green)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(appliedCoupon.code)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(appliedCoupon.description)
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation {
                            self.appliedCoupon = nil
                            self.couponCode = ""
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(.red)
                    }
                }
                .padding()
                .background(Color.green.opacity(0.05))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.green, lineWidth: 1)
                )
            } else {
                HStack(spacing: 12) {
                    Image(systemName: "tag.fill")
                        .foregroundColor(.black)
                        .font(.title3)
                    
                    TextField("Enter promo code", text: $couponCode)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                    
                    Button {
                        applyCoupon()
                    } label: {
                        Text("Apply")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(couponCode.isEmpty ? Color.gray : AppColors.primary)
                            .cornerRadius(8)
                    }
                    .disabled(couponCode.isEmpty)
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Available Codes:")
                        .font(.caption.bold())
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 8) {
                        CouponHintBadge(code: "50OFF", color: .purple)
                        CouponHintBadge(code: "SAVE10%", color: .orange)
                        CouponHintBadge(code: "-50LE", color: .pink)
                    }
                }
                .padding(.top, 8)
            }
        }
    }
    
    // MARK: - Shipping Address Section
    private var shippingAddressSection: some View {
        
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                       Text("Shipping Address")
                           .font(.title2.bold())
                       Spacer()
                       
                       Button {
                           showAddAddress = true
                       } label: {
                           HStack(spacing: 4) {
                               Text(addresses.isEmpty ? "Add" : "Change")
                                   .font(.subheadline.bold())
                               Image(systemName: "chevron.right")
                                   .font(.caption)
                           }
                           .foregroundColor(.black)
                       }
                   }
            
            if let address = defaultAddress {
                // Address Card
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "location.fill")
                            .font(.title3)
                            .foregroundColor(AppColors.primary)
                        
                        Text(defaultAddress!.name)
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 8) {
                            Image(systemName: "house.fill")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(width: 16)
                            Text(defaultAddress!.street)
                                .font(.body)
                        }
                        
                        HStack(spacing: 8) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(width: 16)
                            Text("\(defaultAddress?.city), \(defaultAddress?.state) \(defaultAddress?.zipCode)")
                                .font(.body)
                        }
                        
                        HStack(spacing: 8) {
                            Image(systemName: "flag.fill")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(width: 16)
                            Text(defaultAddress!.country)
                                .font(.body)
                        }
                        
                        if let phone = defaultAddress?.phone {
                            HStack(spacing: 8) {
                                Image(systemName: "phone.fill")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .frame(width: 16)
                                Text(phone)
                                    .font(.body)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.black.opacity(0.05))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black.opacity(0.3), lineWidth: 1)
                )
            } else {
                // No Address Card
                NavigationLink {
                    AddressesListView()
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.orange)
                                Text("No Address Selected")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                            }
                            
                            Text("Add a delivery address to continue")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(AppColors.primary)
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                    )
                }
            }
        }
        .sheet(isPresented: $showAddAddress) {
               AddAddressView(num: 0)
           }
           .onAppear {
               viewModel.setModelContext(modelContext)
               viewModel.refreshAddresses()
           }
    }
    
    // MARK: - Order Summary
    private var orderSummarySection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Order Summary")
                .font(.title2.bold())
            
            VStack(spacing: 20) {
                ForEach(CartManager.shared.productsInCart) { item in
                    let basePrice = Double(item.product.variants.first?.price ?? item.product.price) ?? 0
                    let converted = basePrice * currencyManager.exchangeRate * Double(item.quantity)
                    
                    HStack(alignment: .top, spacing: 12) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.product.title)
                                .font(.body)
                                .lineLimit(2)
                            Text("Qty: \(item.quantity)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text("\(currencyManager.getCurrencySymbol())\(String(format: "%.2f", converted))")
                            .font(.body.bold())
                    }
                }
                
                Divider()
                
                VStack(spacing: 12) {
                    HStack {
                        Text("Subtotal")
                            .font(.body)
                        Spacer()
                        let baseTotal = CartManager.shared.totalCartValueInUSD
                        let convertedTotal = baseTotal * currencyManager.exchangeRate
                        Text("\(currencyManager.getCurrencySymbol())\(String(format: "%.2f", convertedTotal))")
                            .font(.body)
                    }
                    
                    if let appliedCoupon = appliedCoupon {
                        HStack {
                            HStack(spacing: 4) {
                                Text("Discount")
                                    .font(.body)
                                Text("(\(appliedCoupon.code))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            let discount = calculateDiscount()
                            Text("-\(currencyManager.getCurrencySymbol())\(String(format: "%.2f", discount))")
                                .font(.body.bold())
                                .foregroundColor(.green)
                        }
                    }
                    
                    HStack {
                        Text("Shipping")
                            .font(.body)
                        Spacer()
                        HStack(spacing: 4) {
                            Text("Free")
                                .font(.body.bold())
                                .foregroundColor(.green)
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Total")
                            .font(.title3.bold())
                        Spacer()
                        let finalTotal = calculateFinalTotal()
                        Text("\(currencyManager.getCurrencySymbol())\(String(format: "%.2f", finalTotal))")
                            .font(.title3.bold())
                            .foregroundColor(AppColors.primary)
                    }
                    .padding(.top, 4)

                    if appliedCoupon != nil {
                        HStack {
                            Spacer()
                            HStack(spacing: 6) {
                                Image(systemName: "gift.fill")
                                    .font(.caption)
                                let discount = calculateDiscount()
                                Text("You saved \(currencyManager.getCurrencySymbol())\(String(format: "%.2f", discount))!")
                                    .font(.caption.bold())
                            }
                            .foregroundColor(.green)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(8)
                            Spacer()
                        }
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
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
                    HStack(spacing: 15) {
                        ZStack {
                            Circle()
                                .fill(vm.selectedPayment == method ? Color.black.opacity(0.1) : Color.gray.opacity(0.1))
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: method.icon)
                                .font(.title3)
                                .foregroundColor(vm.selectedPayment == method ? .black : .gray)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(method.rawValue)
                                .font(.body.bold())
                                .foregroundColor(.primary)
                            
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
                                .foregroundColor(.black)
                                .font(.title2)
                        } else {
                            Image(systemName: "circle")
                                .foregroundColor(.gray.opacity(0.3))
                                .font(.title2)
                        }
                    }
                    .padding()
                    .background(vm.selectedPayment == method ? Color.black.opacity(0.05) : Color.clear)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(vm.selectedPayment == method ? Color.black : Color.gray.opacity(0.2), lineWidth: vm.selectedPayment == method ? 2 : 1)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    // MARK: - Test Mode Notice
    private var testModeNotice: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "info.circle.fill")
                    .font(.title3)
                    .foregroundColor(.orange)
                Text("Important Information")
                    .font(.headline)
                    .foregroundColor(.orange)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "arrow.clockwise")
                        .font(.caption)
                        .foregroundColor(.orange)
                        .frame(width: 16)
                    Text("Refund or exchange available for 7 days from delivery")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "checkmark.shield")
                        .font(.caption)
                        .foregroundColor(.orange)
                        .frame(width: 16)
                    Text("Verify your shipping information for fast delivery")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if vm.selectedPayment == .paypal {
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "testtube.2")
                            .font(.caption)
                            .foregroundColor(.orange)
                            .frame(width: 16)
                        Text("Test mode: Use PayPal sandbox account")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color.orange.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Pay Button
    private var payButton: some View {
        Button {
            processPayment()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: vm.selectedPayment.icon)
                    .font(.title3)
                
                VStack(spacing: 2) {
                    if vm.selectedPayment == .cashOnDelivery {
                        Text("Place Order")
                            .font(.headline)
                    } else {
                        Text("Pay with PayPal")
                            .font(.headline)
                    }
                    
                    let baseTotal = CartManager.shared.totalCartValueInUSD
                    let convertedTotal = baseTotal * currencyManager.exchangeRate
                    let finalTotal = calculateFinalTotal()
                    Text("\(currencyManager.getCurrencySymbol())\(String(format: "%.2f", finalTotal))")
                        .font(.subheadline)
                        .opacity(0.9)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    colors: vm.selectedPayment == .cashOnDelivery ? [AppColors.primary, AppColors.primary.opacity(0.8)] : [Color.black, Color.gray.opacity(0.9)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(14)
            .shadow(color: (vm.selectedPayment == .cashOnDelivery ? AppColors.primary : AppColors.black).opacity(0.2), radius: 8, x: 0, y: 4)
        }
        .padding(.top, 10)
        .disabled(defaultAddress == nil)
        .opacity(defaultAddress == nil ? 0.5 : 1)
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
                
                Text(vm.selectedPayment == .paypal ? "Opening PayPal..." : "Processing Order...")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("Please wait")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray.opacity(0.95))
            )
            .shadow(radius: 20)
        }
    }
    
    // MARK: - Process Payment
    private func processPayment() {
        if vm.selectedPayment == .cashOnDelivery {
            processCashOnDelivery()
        } else {
            processPayPalPayment()
        }
    }
    
    private func processCashOnDelivery() {
        vm.showPaymentProcessing = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            vm.showPaymentProcessing = false
            
            let finalTotal = calculateFinalTotal()
            let displayTotal = "\(currencyManager.getCurrencySymbol())\(String(format: "%.2f", finalTotal))"
            
            var message = """
            Your order has been placed successfully!
            
            Order Total: \(displayTotal)
            
            Payment Method: Cash on Delivery
            """
            
            if let coupon = appliedCoupon {
                let discount = calculateDiscount()
                message += """
                
                
                Discount Applied: \(coupon.code)
                You Saved: \(currencyManager.getCurrencySymbol())\(String(format: "%.2f", discount))
                """
            }
            
            message += "\n\nYou will pay when you receive your order."
            
            vm.paymentMessage = message
            vm.showSuccessAlert = true
            Task {
                do { try await createShopifyOrder() }
                catch { print(" Shopify order creation failed: \(error.localizedDescription)") }
            }
        }
    }
    
    private func processPayPalPayment() {
        vm.showPaymentProcessing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            Checkout.start()
        }
        Task {
            do { try await createShopifyOrder() }
            catch { print(" Shopify order creation failed: \(error.localizedDescription)") }
        }
    }
    
    // MARK: - Coupon Logic
      func applyCoupon() {
        let code = couponCode.uppercased().trimmingCharacters(in: .whitespaces)
        
        switch code {
        case "50OFF":
            appliedCoupon = AppliedCoupon(
                code: code,
                type: .percentage(50),
                description: "50% off your order"
            )
            couponCode = ""
            
        case "SAVE10%":
            appliedCoupon = AppliedCoupon(
                code: code,
                type: .percentage(10),
                description: "10% off your order"
            )
            couponCode = ""
            
        case "-50LE":
            appliedCoupon = AppliedCoupon(
                code: code,
                type: .fixedAmount(50),
                description: " -50 on your order"
            )
            couponCode = ""
            
        default:
            couponErrorMessage = "Invalid coupon code. Please try again"
            showCouponError = true
        }
    }
    
    private func calculateDiscount() -> Double {
        guard let coupon = appliedCoupon else { return 0 }
        
        let baseTotal = CartManager.shared.totalCartValueInUSD
        let convertedTotal = baseTotal * currencyManager.exchangeRate
        
        switch coupon.type {
        case .percentage(let percent):
            return convertedTotal * (Double(percent) / 100.0)
            
        case .fixedAmount(let amount):
            if currencyManager.selectedCurrency == "EGP" {
                return min(Double(amount), convertedTotal)
            } else {
                let egpToUSD = 1.0 / 49.5
                let amountInUSD = Double(amount) * egpToUSD
                let amountInCurrentCurrency = amountInUSD * currencyManager.exchangeRate
                return min(amountInCurrentCurrency, convertedTotal)
            }
        }
    }
    
    private func calculateFinalTotal() -> Double {
        let baseTotal = CartManager.shared.totalCartValueInUSD
        let convertedTotal = baseTotal * currencyManager.exchangeRate
        let discount = calculateDiscount()
        return max(0, convertedTotal - discount) // Ensure total doesn't go negative
    }
}

// MARK: - Coupon Models
struct AppliedCoupon {
    let code: String
    let type: CouponType
    let description: String
}

enum CouponType {
    case percentage(Int)
    case fixedAmount(Int)
}

// MARK: - Coupon Hint Badge
struct CouponHintBadge: View {
    let code: String
    let color: Color
    
    var body: some View {
        Text(code)
            .font(.caption2.bold())
            .foregroundColor(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.1))
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
    }
}
private func createShopifyOrder() async throws {
            print("Creating Shopify order...")

            let userEmail = Auth.auth().currentUser?.email ?? ""

            let url = URL(string: "\(AppConstant.baseUrl)/orders.json")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(AppConstant.shopifyAccessToken, forHTTPHeaderField: "X-Shopify-Access-Token")

            let lineItems: [[String: Any]] = CartManager.shared.productsInCart.map { cartItem in
                let priceStr = cartItem.product.variants.first?.price ?? cartItem.product.price
                return [
                    "title": cartItem.product.title,
                    "quantity": cartItem.quantity,
                    "price": priceStr
                ]
            }

            let body: [String: Any] = [
                "order": [
                    "email": userEmail,
                    "send_receipt": true,
                    "send_fulfillment_receipt": true,
                    "financial_status": "paid",
                    "payment_gateway_names": ["PayPal"],
                    "line_items": lineItems,
                    "shipping_address": [
                        "address1": "address",
                        "first_name": "Prodify",
                        "last_name": "User",
                        "country": "Egypt"
                    ]
                ]
            ]

            request.httpBody = try JSONSerialization.data(withJSONObject: body)

            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse else {
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
            }

            if http.statusCode == 201 {
                print(" Shopify order created successfully")
            } else {
                let msg = String(data: data, encoding: .utf8) ?? "Unknown error"
                print(" Shopify order creation failed: \(msg)")
                throw NSError(domain: "", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: msg])
            }
        }
