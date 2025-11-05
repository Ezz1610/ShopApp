//
//  HomeViewModel.swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 23/10/2025.
//

import Foundation
@MainActor
final class HomeViewModel: ObservableObject {
    @Published var brands: [SmartCollection] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let api: ApiServices

    // Dependency injection for easier testing
    init(api: ApiServices = ApiServices.shared) {
        self.api = api
    }

    /// Loads smart collections (brands) from the API
    func loadBrands() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let fetchedBrands = try await api.fetchSmartCollections()
            brands = fetchedBrands
        } catch {
            errorMessage = error.localizedDescription
            brands = [] // clear stale data on error
        }
    }
}
