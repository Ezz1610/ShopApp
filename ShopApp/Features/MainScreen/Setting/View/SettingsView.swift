//
//  Settings.swift
//  ShopApp
//
//  Created by Soha Elgaly on 23/10/2025.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    var body: some View {
        NavigationView {
            
            List {
                Section {
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.blue)
                        VStack(alignment: .leading) {
                            Text(viewModel.username)
                                .font(.headline)
                            Text(viewModel.email)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }

    
                Section(header: Text("General")) {
                    HStack(spacing: -10){
                        Label("Location", systemImage: "mappin.circle")
                        Spacer()
                            .onAppear{
                                viewModel.requestUserLocation()
                            }
                        Text("\(viewModel.location)")
                    }
                    Picker(selection: $viewModel.selectedCurrency, label: Label("Currency", systemImage: "dollarsign.circle")) {
                        ForEach(viewModel.currencies, id: \.self) { currency in
                            Text(currency)
                        }
                    }
                }

                Section(header: Text("App Settings")) {
                    Toggle(isOn: $viewModel.isDarkMode) {
                        Label("Dark Mode", systemImage: "moon.circle")
                    }

                    NavigationLink(destination: AboutUsView()) {
                        Label("About Us", systemImage: "info.circle")
                    }
                }
                
            
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Settings")
        }
    }
}

struct AboutUsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            Text("About Us")
                .font(.title)
                .bold()
            Text("This app was built to make your shopping experience smooth and enjoyable.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
        }
        .padding()
    }
}


