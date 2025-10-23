//
//  TestHomeScreen.swift
//  ShopApp
//
//  Created by mohamed ezz on 22/10/2025.
//

import Foundation
import SwiftUI

struct TestHomeScreen: View {
    @State private var nearbyCities: [City] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        VStack {
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
        do {
            let cities = try await LocationHelper.shared.getNearbyCities(limit: 10)
            nearbyCities = cities
        } catch {
            errorMessage = "Failed to load cities: \(error.localizedDescription)"
        }
        isLoading = false
    }
}
