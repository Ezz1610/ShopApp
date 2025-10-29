//
//  TestHomeScreen.swift
//  ShopApp
//
//  Created by mohamed ezz on 22/10/2025.

import SwiftUI
import SwiftData

struct TestHomeScreen: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject var navigator: AppNavigator

    @State private var nearbyCities: [City] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    @StateObject private var viewModel: ProductViewModel

//    init(context: ModelContext) {
//        _viewModel = StateObject(wrappedValue: ProductViewModel(context: context))
//    }

    var body: some View {
        VStack {
            Button(action: {
                Task {
                    await viewModel.fetchProducts()
                 //   navigator.goTo(.productsView)
                }
            }) {
                Text("Load Products")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }     
            Button(action: {
                Task {
                  //  navigator.goTo(.favoritesView)
                }
            }) {
                Text("Load Favorites Products")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }

            CouponsView()

            Text("Nearby Cities")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            if isLoading {
                ProgressView("Loading nearby cities...")
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else if nearbyCities.isEmpty {
                Text("No nearby cities found")
                    .foregroundColor(.gray)
            } else {
                List(nearbyCities) { city in
                    VStack(alignment: .leading) {
                        Text(city.name)
                            .font(.headline)
                        Text("\(Int(city.distance)) meters away")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .task {
            await loadNearbyCities()
        }
    }

    private func loadNearbyCities() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let cities = try await LocationHelper.shared.getNearbyCities(limit: 10)
            nearbyCities = cities
        } catch {
            errorMessage = "Failed to load cities: \(error.localizedDescription)"
        }
    }
}
