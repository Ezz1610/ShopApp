//
//  Settings.swift
//  ShopApp
//
//  Created by Soha Elgaly on 23/10/2025.
//

import SwiftUI
import _SwiftData_SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Bindable var currencyManager = CurrencyManager.shared
    @EnvironmentObject var navigator: AppNavigator

    @State private var showLogoutAlert = false
    
    var body: some View {
        NavigationStack {
            List {
            
                userProfileSection
                currencySection
                addressesSection
                ordersSection
                supportSection
                logoutSection
            }
            
            .listStyle(InsetGroupedListStyle())
               .scrollIndicators(.hidden)
               .navigationTitle("Settings")
               .alert("Log Out", isPresented: $showLogoutAlert) {
                   Button("Cancel", role: .cancel) {}
                   Button("Log Out", role: .destructive) {
                       viewModel.logout(navigator: navigator)
                   }
               } message: {
                   Text("Are you sure you want to log out?")
               }
               // 👇 FIX: Add space above your custom tab bar
               .safeAreaInset(edge: .bottom) {
                   Color.clear.frame(height: 100) // Adjust height to match your tab bar
               }
           }
    }
    
    // MARK: - User Profile Section
    private var userProfileSection: some View {
        Section {
            HStack(spacing: 15) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(viewModel.username)
                        .font(.title3.bold())
                    Text(viewModel.email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if !viewModel.location.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.caption)
                            Text(viewModel.location)
                                .font(.caption)
                        }
                        .foregroundColor(.secondary)
                        .padding(.top, 2)
                    }
                }
            }
            .padding(.vertical, 8)
        }
        .onAppear {
            viewModel.requestUserLocation()
        }
    }
    
    // MARK: - Currency Section
    private var currencySection: some View {
        Section {
            NavigationLink {
                CurrencySelectionView()
            } label: {
                HStack(spacing: 15) {
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                        .frame(width: 32)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Currency")
                            .font(.body)
                        Text(currencyManager.selectedCurrency)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Text(currencyManager.getCurrencySymbol())
                            .font(.headline)
                            .foregroundColor(.blue)
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        } header: {
            Text("Preferences")
        }
    }
    
    // MARK: - Addresses Section
    private var addressesSection: some View {
        Section {
            NavigationLink {
                AddressesListView()
            } label: {
                HStack(spacing: 15) {
                    Image(systemName: "house.circle.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                        .frame(width: 32)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Addresses")
                            .font(.body)
                        if let defaultAddress = viewModel.defaultAddress {
                            Text(defaultAddress)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        } else {
                            Text("No default address")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        } header: {
            Text("Account")
        }
    }
    
    // MARK: - Orders Section
    private var ordersSection: some View {
        Section {
                HStack(spacing: 15) {
                    Image(systemName: "shippingbox.circle.fill")
                        .font(.title2)
                        .foregroundColor(.purple)
                        .frame(width: 32)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Orders")
                            .font(.body)
                        Text("View your order history")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                
            }
                .contentShape(Rectangle()) // ⬅️ makes the entire area tappable
                .onTapGesture {
                    navigator.goTo(.ordersView, replaceLast: false) // ⬅️ handle your action here
                }
            
        }
    }
    
    // MARK: - Support Section
    private var supportSection: some View {
        Section {
            NavigationLink {
                ContactUsView()
            } label: {
                HStack(spacing: 15) {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .frame(width: 32)
                    
                    Text("Contact Us")
                        .font(.body)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            NavigationLink {
                AboutUsView()
            } label: {
                HStack(spacing: 15) {
                    Image(systemName: "info.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .frame(width: 32)
                    
                    Text("About Us")
                        .font(.body)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        } header: {
            Text("Support")
        }
    }
    
    // MARK: - Logout Section
    private var logoutSection: some View {
        Section {
                     Button(role: .destructive) {
                                        viewModel.logout(navigator: navigator)
                                    } label: {
                                        HStack {
                                            Image(systemName: "arrow.backward.circle.fill")
                                            Text("Logout")
                                        }
                                    }
                                }
    }
}

// MARK: - Currency Selection View
struct CurrencySelectionView: View {
    @Bindable var currencyManager = CurrencyManager.shared
    @Environment(\.dismiss) var dismiss

    var body: some View {
        List {
            ForEach(currencyManager.supportedCurrencies, id: \.self) { currency in
                Button {
                    currencyManager.updateCurrency(to: currency)
                    // dismiss()
                } label: {
                    HStack(spacing: 15) {
                     
                        Text(currencyManager.currencySymbols[currency] ?? "$")
                            .font(.system(size: 32))
                            .frame(width: 50, height: 50)
                            .background(
                                Circle()
                                    .fill(currencyManager.selectedCurrency == currency ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(currency)
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text(getCurrencyName(currency))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        if currencyManager.selectedCurrency == currency {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            Section {
                if currencyManager.isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Text("Updating rates...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding()
                } else if let lastUpdate = currencyManager.lastUpdateTime {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Exchange Rate")
                                .font(.caption.bold())
                            Spacer()
                            Text("1 USD = \(String(format: "%.4f", currencyManager.exchangeRate)) \(currencyManager.selectedCurrency)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("Last Updated")
                                .font(.caption.bold())
                            Spacer()
                            Text(lastUpdate.formatted(date: .omitted, time: .shortened))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                if let error = currencyManager.errorMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
            }
        }
        .navigationTitle("Select Currency")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    currencyManager.refreshRates()
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .disabled(currencyManager.isLoading)
            }
        }
    }
    
    private func getCurrencyName(_ code: String) -> String {
        switch code {
        case "USD": return "US Dollar"
        case "EUR": return "Euro"
        case "GBP": return "British Pound"
        case "EGP": return "Egyptian Pound"
        case "SAR": return "Saudi Riyal"
        case "AED": return "UAE Dirham"
        case "AUD": return "Australian Dollar"
        case "CAD": return "Canadian Dollar"
        case "JPY": return "Japanese Yen"
        default: return code
        }
    }
}

// MARK: - Addresses List View
struct AddressesListView: View {
    @ObservedObject var viewModel = AddressesViewModel.shared
    @State private var showAddAddress = false
    @Environment(\.modelContext) private var modelContext
    @Query private var addresses: [Address]
    
    var body: some View {
        ZStack {
            if addresses.isEmpty {
                emptyAddressesView
            } else {
                List {
                    ForEach(addresses) { address in
                        AddressRowView(
                            address: address,
                            isDefault: address.id == viewModel.defaultAddressId
                        ) {
                            viewModel.setDefaultAddress(address.id)
                        }
                    }
                    .onDelete { offsets in
                        deleteAddresses(at: offsets)
                    }
                }
            }
        }
        .navigationTitle("Addresses")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showAddAddress = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddAddress) {
            AddAddressView()
        }
        .onAppear {
            viewModel.setModelContext(modelContext)
            viewModel.refreshAddresses()
        }
    }
    
    private func deleteAddresses(at offsets: IndexSet) {
        for index in offsets {
            let address = addresses[index]
            viewModel.deleteAddress(address)
        }
    }
    
    private var emptyAddressesView: some View {
        VStack(spacing: 20) {
            Image(systemName: "house.fill")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Addresses")
                .font(.title2.bold())
            
            Text("Add your delivery addresses to make checkout faster")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button {
                showAddAddress = true
            } label: {
                Text("Add Address")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: 200)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
        }
        .padding()
    }
}

// MARK: - Address Row View
struct AddressRowView: View {
    let address: Address
    let isDefault: Bool
    let onSetDefault: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(address.name)
                    .font(.headline)
                
                Spacer()
                
                if isDefault {
                    Text("Default")
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue)
                        .cornerRadius(6)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(address.street)
                    .font(.body)
                    .foregroundColor(.primary)
                
                Text("\(address.city), \(address.state) \(address.zipCode)")
                    .font(.body)
                    .foregroundColor(.primary)
                
                Text(address.country)
                    .font(.body)
                    .foregroundColor(.primary)
                
                if let phone = address.phone {
                    Text(phone)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            if !isDefault {
                Button {
                    onSetDefault()
                } label: {
                    Text("Set as Default")
                        .font(.caption.bold())
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Add Address View
struct AddAddressView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var name = ""
    @State private var street = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zipCode = ""
    @State private var country = ""
    @State private var phone = ""
    @State private var setAsDefault = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Contact Information") {
                    TextField("Full Name", text: $name)
                    TextField("Phone Number", text: $phone)
                        .keyboardType(.phonePad)
                }
                
                Section("Address") {
                    TextField("Street Address", text: $street)
                    TextField("City", text: $city)
                    TextField("State/Province", text: $state)
                    TextField("ZIP/Postal Code", text: $zipCode)
                    TextField("Country", text: $country)
                }
                
                Section {
                    Toggle("Set as default address", isOn: $setAsDefault)
                }
            }
            .navigationTitle("Add Address")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveAddress()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        !name.isEmpty && !street.isEmpty && !city.isEmpty && !state.isEmpty && !zipCode.isEmpty && !country.isEmpty
    }
    
    private func saveAddress() {
        let address = Address(
            name: name,
            street: street,
            city: city,
            state: state,
            zipCode: zipCode,
            country: country,
            phone: phone.isEmpty ? nil : phone
        )
        
        // Insert into SwiftData context
        modelContext.insert(address)
        
        // Save context
        do {
            try modelContext.save()
            
            // Set as default if needed
            AddressesViewModel.shared.setModelContext(modelContext)
            if setAsDefault {
                AddressesViewModel.shared.setDefaultAddress(address.id)
            }
            
            dismiss()
        } catch {
            print("Error saving address: \(error.localizedDescription)")
        }
    }
}
// MARK: - Orders List View
struct OrdersListView: View {
    // TODO: Add your OrdersViewModel here
    // @StateObject private var viewModel = OrdersViewModel()
    
    var body: some View {
        ZStack {
            // TODO: Replace this with actual orders list
            VStack(spacing: 20) {
                Image(systemName: "shippingbox.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                
                Text("Orders")
                    .font(.title2.bold())
                
                Text("Your order history will appear here")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                // TODO: Add your orders list implementation here
                // Example structure:
                // List {
                //     ForEach(viewModel.orders) { order in
                //         OrderRowView(order: order)
                //     }
                // }
            }
            .padding()
        }
        .navigationTitle("Orders")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Contact Us View
struct ContactUsView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var message = ""
    @State private var showSuccessAlert = false
    
    var body: some View {
        Form {
            Section("Your Information") {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
            }
            
            Section("Message") {
                TextEditor(text: $message)
                    .frame(minHeight: 150)
            }
            
            Section {
                Button {
                    sendMessage()
                } label: {
                    HStack {
                        Spacer()
                        Text("Send Message")
                            .font(.headline)
                        Spacer()
                    }
                }
                .disabled(!isFormValid)
            }
            
            Section("Other Ways to Reach Us") {
                Link(destination: URL(string: "mailto:support@yourshopify.com")!) {
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.blue)
                        Text("support@yourshopify.com")
                    }
                }
                
                Link(destination: URL(string: "tel:+1234567890")!) {
                    HStack {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.green)
                        Text("+20 (134) 567-890")
                    }
                }
            }
        }
        .navigationTitle("Contact Us")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Message Sent!", isPresented: $showSuccessAlert) {
            Button("OK") {
                name = ""
                email = ""
                message = ""
            }
        } message: {
            Text("We'll get back to you as soon as possible.")
        }
    }
    
    private var isFormValid: Bool {
        !name.isEmpty && !email.isEmpty && !message.isEmpty && email.contains("@")
    }
    
    private func sendMessage() {
        print("Sending message from: \(name) (\(email))")
        print("Message: \(message)")
        showSuccessAlert = true
    }
}

// MARK: - About Us View
struct AboutUsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Image(systemName: "cart.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                    .padding(.top, 40)
                
                VStack(spacing: 15) {
                    Text("About Our Store")
                        .font(.title.bold())
                    
                    Text("Welcome to our Shopify shopping app!")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    InfoRow(icon: "sparkles", title: "Our Mission", description: "To provide you with the best shopping experience, offering quality products at great prices.")
                    
                    InfoRow(icon: "heart.fill", title: "Why Choose Us", description: "We carefully curate our products and ensure fast, reliable delivery to your doorstep.")
                    
                    InfoRow(icon: "shield.fill", title: "Secure Shopping", description: "Your security is our priority. All transactions are encrypted and protected.")
                }
                .padding(.horizontal)
                
                Spacer(minLength: 40)
                
                Text("Version 1.0.0")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .navigationTitle("About Us")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
    }
}



