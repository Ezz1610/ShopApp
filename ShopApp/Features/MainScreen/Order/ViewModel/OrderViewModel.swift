//
//  OrderCard.swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 09/11/2025.
//
import Foundation

@MainActor
final class OrderViewModel: ObservableObject {
    @Published var orders: [ShopifyOrder] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?



    // MARK: - Fetch orders for current user
    func fetchOrders(for email: String) async {
        isLoading = true
        defer { isLoading = false }

        guard let url = URL(string: "https://\(AppConstant.baseUrl)/admin/api/2025-07/orders.json?email=\(email)") else {
            errorMessage = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(AppConstant.shopifyAccessToken, forHTTPHeaderField: "X-Shopify-Access-Token")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                let msg = String(data: data, encoding: .utf8) ?? "Unknown error"
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: msg])
            }

            let decoded = try JSONDecoder().decode(ShopifyOrdersResponse.self, from: data)
            self.orders = decoded.orders.sorted(by: { $0.created_at ?? "" > $1.created_at ?? "" })

        } catch {
            errorMessage = "Failed to fetch orders: \(error.localizedDescription)"
        }
    }
}
