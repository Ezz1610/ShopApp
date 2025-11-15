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
    @State private var currentCity: String = ""
    @State private var showLogoutAlert = false
  
    
    var body: some View {
//        NavigationStack {
            List {
            
                userProfileSection
                currencySection
                SettingsAddressSection()
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
               
               .safeAreaInset(edge: .bottom) {
                   Color.clear.frame(height: 100)
               }
//           }
    }
    
    private var userProfileSection: some View {
        Section {
            HStack(spacing: 15) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 70))
                    .foregroundColor(AppColors.primary)
                
                VStack(alignment: .leading, spacing: 5) {
                  
                    Text(viewModel.username)
                        .font(.title3.bold())
                    Text(viewModel.email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                  
                    if !currentCity.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.caption)
                            Text(currentCity)
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
            Task {
                do {
                    let city = try await LocationHelper.shared.getCurrentCity()
                    await MainActor.run {
                        currentCity = city.name
                    }
                } catch {
                    print("❌ Failed to get current city:", error)
                    await MainActor.run {
                        currentCity = "Unknown"
                    }
                }
            }
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
                            .foregroundColor(.green)

                    }
                }
            }
        } header: {
            Text("Preferences")
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
                .contentShape(Rectangle())
                .onTapGesture {
                    navigator.goTo(.ordersView, replaceLast: false)
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
                        .foregroundColor(AppColors.primary)
                        .frame(width: 32)
                    
                    Text("Contact Us")
                        .font(.body)
                    
                    Spacer()
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
                  
                } label: {
                    HStack(spacing: 15) {
                     
                        Text(currencyManager.currencySymbols[currency] ?? "$")
                            .font(.system(size: 32))
                            .frame(width: 50, height: 50)
                            .background(
                                Circle()
                                    .fill(currencyManager.selectedCurrency == currency ? Color.black.opacity(0.1) : Color.gray.opacity(0.1))
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
                                .foregroundColor(.black)
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




    // MARK: - Orders List View
    struct OrdersListView: View {
        // TODO: Add your OrdersViewModel here
        
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
                                .foregroundColor(.green)
                            Text("support@yourshopapp.com")
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
                        .foregroundColor(.black)
                        .padding(.top, 40)
                    
                    VStack(spacing: 15) {
                        Text("About Our Store")
                            .font(.title.bold())
                        
                        Text("Welcome to our ShopApp application!")
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
                    .foregroundColor(.black)
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
    
    


// MARK: - Addresses List View
struct AddressesListView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var navigator: AppNavigator
    @Query private var addresses: [Address]
    @State private var num = 0
    // Track where we came from
    var sourceView: AddressSourceView = .settings
    
    private var defaultAddress: Address? {
        addresses.first { $0.isDefault }
    }
    
    var body: some View {
        ZStack {
            if addresses.isEmpty {
                emptyStateView
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        // Default Address Card
                        if let defaultAddr = defaultAddress {
                            defaultAddressCard(defaultAddr)
                        }
                        
                        // Other Addresses
                        let otherAddresses = addresses.filter { !$0.isDefault }
                        if !otherAddresses.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Other Addresses")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal)
                                
                                ForEach(otherAddresses) { address in
                                    addressCard(address)
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .navigationTitle("My Addresses")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    navigator.goBack()
                    
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            }
            
            if !addresses.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        navigator.goTo(.addAddress, replaceLast: false)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundColor(AppColors.primary)
                    }
                }
            }
        }
    }
    
    // MARK: - Default Address Card
    private func defaultAddressCard(_ address: Address) -> some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.green)
                    Text("Default Address")
                        .font(.subheadline.bold())
                        .foregroundColor(.green)
                }
                Spacer()
                Menu {
                    Button(role: .destructive) {
                        deleteAddress(address)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color.green.opacity(0.1))
            
            // Address Content
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(AppColors.primary)
                        .frame(width: 24)
                    Text(address.name)
                        .font(.headline)
                }
                
                Divider()
                
                HStack(alignment: .top) {
                    Image(systemName: "location.fill")
                        .foregroundColor(AppColors.primary)
                        .frame(width: 24)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(address.street)
                        Text("\(address.city), \(address.state)")
                        Text("\(address.zipCode), \(address.country)")
                    }
                    .font(.body)
                }
                
                if let phone = address.phone {
                    HStack {
                        Image(systemName: "phone.fill")
                            .foregroundColor(AppColors.primary)
                            .frame(width: 24)
                        Text(phone)
                            .font(.body)
                    }
                }
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.green.opacity(0.2), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
    
    // MARK: - Regular Address Card
    private func addressCard(_ address: Address) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(address.name)
                        .font(.headline)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(address.street), \(address.city)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                Menu {
                    Button {
                        setAsDefault(address)
                    } label: {
                        Label("Set as Default", systemImage: "checkmark.circle")
                    }
                    
                    Divider()
                    
                    Button(role: .destructive) {
                        deleteAddress(address)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle.fill")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            // Quick Info
            HStack(spacing: 20) {
                Label(address.state, systemImage: "building.2")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if let phone = address.phone {
                    Label(phone, systemImage: "phone")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Set as Default Button
            Button {
                setAsDefault(address)
            } label: {
                HStack {
                    Image(systemName: "checkmark.circle")
                    Text("Set as Default")
                }
                .font(.subheadline.bold())
                .foregroundColor(AppColors.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(AppColors.primary.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .padding(.horizontal)
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.primary.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "house.fill")
                    .font(.system(size: 50))
                    .foregroundColor(AppColors.primary)
            }
            
            VStack(spacing: 8) {
                Text("No Addresses Yet")
                    .font(.title2.bold())
                
                Text("Add your first delivery address to get started with fast checkout")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button {
                navigator.goTo(.addAddress, replaceLast: false)
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Address")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: 280)
                .padding()
                .background(AppColors.primary)
                .cornerRadius(14)
            }
            
            Spacer()
        }
        .padding()
    }
    
    // MARK: - Actions
    private func setAsDefault(_ address: Address) {
        // Remove default from all
        for addr in addresses {
            addr.isDefault = false
        }
        
        // Set new default
        address.isDefault = true
        
        do {
            try modelContext.save()
        } catch {
            print("Error setting default: \(error)")
        }
    }
    
    private func deleteAddress(_ address: Address) {
        modelContext.delete(address)
        
        do {
            try modelContext.save()
            
            // If deleted was default and there are other addresses, set first as default
            if address.isDefault && !addresses.isEmpty {
                addresses.first?.isDefault = true
                try modelContext.save()
            }
        } catch {
            print("Error deleting: \(error)")
        }
    }
}

// MARK: - Add/Edit Address View
struct AddAddressView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var navigator: AppNavigator
    @Query private var addresses: [Address]
    
    @State private var name = ""
    @State private var street = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zipCode = ""
    @State private var country = "Egypt"
    @State private var phone = ""
    @State private var setAsDefault = false
    @State private var nearbyCities: [City] = []
    @State private var isLoadingCities = false
    
    private var isFirstAddress: Bool {
        addresses.isEmpty
    }
    
    private var isFormValid: Bool {
        !name.isEmpty &&
        !street.isEmpty &&
        !city.isEmpty &&
        !state.isEmpty &&
        !zipCode.isEmpty &&
        !country.isEmpty &&
        isPhoneValid
    }
    
    private var isPhoneValid: Bool {
        phone.isEmpty || phone.count >= 10
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Info Banner
                if isFirstAddress {
                    infoBanner
                }
                
                // Contact Section
                VStack(alignment: .leading, spacing: 16) {
                    sectionHeader("Contact Information", icon: "person.fill")
                    
                    CustomTextField(
                        iconName: "person",
                        placeholder: "Full Name",
                        text: $name
                    )
                    
                    CustomTextField(
                        iconName: "phone",
                        placeholder: "Phone Number",
                        text: $phone,
                        keyboardType: .phonePad
                    )
                    .onChange(of: phone) { _ in
                        phone = phone.filter { $0.isNumber }
                    }
                    
                    if !phone.isEmpty && !isPhoneValid {
                        Label("Please enter a valid phone number (min 10 digits)", systemImage: "exclamationmark.circle")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                
                // Address Section
                VStack(alignment: .leading, spacing: 16) {
                    sectionHeader("Address Details", icon: "location.fill")
                    
                    CustomTextField(
                        iconName: "road.lanes",
                        placeholder: "Street Address",
                        text: $street
                    )
                    
                    // City Picker
                    if isLoadingCities {
                        HStack {
                            ProgressView()
                            Text("Loading cities...")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                    } else if !nearbyCities.isEmpty {
                        Menu {
                            ForEach(nearbyCities) { cityItem in
                                Button(cityItem.name) {
                                    city = cityItem.name
                                }
                            }
                        } label: {
                            HStack {
                                Image(systemName: "building.2")
                                    .foregroundColor(AppColors.primary)
                                Text(city.isEmpty ? "Select City" : city)
                                    .foregroundColor(city.isEmpty ? .secondary : .primary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                        }
                    } else {
                        CustomTextField(
                            iconName: "building.2",
                            placeholder: "City",
                            text: $city
                        )
                    }
                    
                    CustomTextField(
                        iconName: "map",
                        placeholder: "State/Province",
                        text: $state
                    )
                    
                    CustomTextField(
                        iconName: "number",
                        placeholder: "ZIP/Postal Code",
                        text: $zipCode,
                        keyboardType: .numberPad
                    )
                    
                    CustomTextField(
                        iconName: "flag",
                        placeholder: "Country",
                        text: $country
                    )
                }
                
                // Default Toggle
                if !isFirstAddress {
                    Toggle(isOn: $setAsDefault) {
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(setAsDefault ? .green : .secondary)
                            Text("Set as default address")
                                .font(.body)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
                
                // Save Button
                Button {
                    saveAddress()
                } label: {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Save Address")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isFormValid ? AppColors.primary : Color.gray)
                    .cornerRadius(14)
                }
                .disabled(!isFormValid)
            }
            .padding()
        }
        .navigationTitle("Add Address")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    navigator.goBack()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            }
        }
        .task {
            await loadNearbyCities()
        }
    }
    
    // MARK: - Info Banner
    private var infoBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: "info.circle.fill")
                .font(.title2)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("First Address")
                    .font(.subheadline.bold())
                Text("This will be set as your default delivery address")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
    
    // MARK: - Section Header
    private func sectionHeader(_ title: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(AppColors.primary)
            Text(title)
                .font(.headline)
        }
    }
    
    // MARK: - Save Address
    private func saveAddress() {
        let address = Address(
            name: name,
            street: street,
            city: city,
            state: state,
            zipCode: zipCode,
            country: country,
            phone: phone.isEmpty ? nil : phone,
            isDefault: isFirstAddress || setAsDefault
        )
        
        // If setting as default, remove default from others
        if address.isDefault {
            for addr in addresses {
                addr.isDefault = false
            }
        }
        
        modelContext.insert(address)
        
        do {
            try modelContext.save()
            navigator.goBack()
        } catch {
            print("Error saving: \(error)")
        }
    }
    
    // MARK: - Load Cities
    private func loadNearbyCities() async {
        isLoadingCities = true
        do {
            nearbyCities = try await LocationHelper.shared.getNearbyCities(limit: 10)
        } catch {
            print("Error loading cities: \(error)")
        }
        isLoadingCities = false
    }
}


// MARK: - Settings Address Section
struct SettingsAddressSection: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var navigator: AppNavigator
    @Query private var addresses: [Address]
    
    private var defaultAddress: Address? {
        addresses.first { $0.isDefault }
    }
    
    var body: some View {
        Section {
            Button {
                navigator.goTo(.addressesView, replaceLast: false)
            } label: {
                HStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .fill(Color.orange.opacity(0.1))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "house.fill")
                            .foregroundColor(.orange)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Addresses")
                            .font(.body.bold())
                            .foregroundColor(.primary)
                        
                        if let addr = defaultAddress {
                            Text("\(addr.city), \(addr.state)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        } else {
                            Text("Add your delivery address")
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
            Text("Delivery")
        }
    }
}


