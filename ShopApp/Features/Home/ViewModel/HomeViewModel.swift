//
//  HomeViewModel.swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 23/10/2025.
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var brands : [SmartCollection] = []
    @Published var isLoadingVendors = false
    @Published var errorMessage: String?

    func load() async {
        guard !isLoadingVendors else { return }
        isLoadingVendors = true
        errorMessage = nil
        do {
            let fetched = try await HomeApiService.shared.fetchSmartCollections()
            self.brands = fetched
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoadingVendors = false
    }
}
