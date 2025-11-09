////
////  ProductsViewModel.swift
////  ShopApp
////
////  Created by Mohammed Hassanien on 23/10/2025.
////
//import Foundation
//
//@MainActor
//final class BrandProductsViewModel: ObservableObject {
//    @Published var products: [ProductModel] = []
//    @Published var isLoading = false
//    @Published var errorMessage: String?
//    
//
//    private let service = ApiServices()
//    let vendor: String
//
//    init(vendor: String) {
//        self.vendor = vendor
//    }
//
//    /// Loads products for the vendor
//    func loadProducts() async {
//        isLoading = true
//        errorMessage = nil
//        defer { isLoading = false }
//
//        do {
//            products = try await service.fetchProducts(byVendor: vendor)
//        } catch {
//            errorMessage = error.localizedDescription
//            products = []
//        }
//    }
//
//}
