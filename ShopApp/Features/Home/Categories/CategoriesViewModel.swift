//
//  CategoriesViewModel.swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 26/10/2025.
//

import Foundation
    

final class CategoriesViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadCategories() {
        if !categories.isEmpty { return }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let data = try await HomeApiService.shared.fetchCategories()

                let cleaned = data
                    .filter { $0.image?.src != nil }
                    .filter { !$0.title.lowercased().contains("home") }

                let priority = ["MEN","WOMEN","KID","SALE"]
                let sorted = cleaned.sorted { a, b in
                    let ia = priority.firstIndex(of: a.title.uppercased()) ?? 999
                    let ib = priority.firstIndex(of: b.title.uppercased()) ?? 999
                    return ia < ib
                }

                let allCategory = Category(
                    id: -1,
                    title: "All",
                    image: nil
                )

                self.categories = [allCategory] + sorted

                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}
