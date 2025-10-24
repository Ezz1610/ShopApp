import SwiftUI
import Combine

@MainActor
final class ProductsViewModel: ObservableObject {
    @Published var products: [ProductModel] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let apiService = ApiServices()

    var filteredProducts: [ProductModel] {
        if searchText.isEmpty {
            return products
        } else {
            return products.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
//                ||
//                $0.vendor.localizedCaseInsensitiveContains(searchText)
//                ||
//                $0.tags.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    func fetchProducts() async {
        isLoading = true
        defer { isLoading = false }

        do {
            products = try await apiService.fetchProducts()
            print("aaaaaaaa\(products.count)")
        } catch {
            errorMessage = error.localizedDescription
            print("aaaaaaaa\(errorMessage)")

        }
    }
}
