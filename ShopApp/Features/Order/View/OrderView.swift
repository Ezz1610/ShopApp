//
//  OrdersPage.swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 09/11/2025.
//

import SwiftUI
import FirebaseAuth

struct OrderView: View {
    @EnvironmentObject private var navigator: AppNavigator

    @StateObject var vm = OrderViewModel()
    @State private var currentEmail = ""
    @State private var refreshID = UUID()
    var body: some View {
            Group {
                header
                if vm.isLoading {
                    ProgressView("Loading orders...")
                } else if let error = vm.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else if vm.orders.isEmpty {
                    Text("No orders found yet.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(vm.orders, id: \.id) { order in
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Order ID: \(order.id)")
                                .font(.headline)

                            if let total = order.total_price {
                                Text("Total: \(total) EGP")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                            }

                            if let status = order.financial_status {
                                Text("Status: \(status.capitalized)")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }

                            if let dateStr = order.created_at {
                                Text("Date: \(formatDate(from: dateStr))")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }

                            if let url = order.order_status_url {
                                Link("View order online", destination: URL(string: url)!)
                                    .font(.footnote)
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.vertical, 6)
                    }
                    .listStyle(.plain)
                    .id(refreshID)
                    .refreshable {
                        await reloadOrders()
                    }
                }
            }
            .task {
                await reloadOrders()
            }
        
    }
    

    private var header: some View {
        HStack {
            Button(action: {
                navigator.goTo(.mainTabView(selectedTab: 2), replaceLast: true)
            }) {
                HStack(spacing: 6) { Image(systemName: "chevron.left"); Text("Settings") }
                    .foregroundColor(.black)
            }
            Spacer()
            Text("My Orders").font(.title2.bold())
            Spacer()
            Spacer().frame(width: 60)
        }
        .padding()
        .background(Color(.systemGray6))
    }

    // MARK: - Reload helper
    private func reloadOrders() async {
        if let user = Auth.auth().currentUser {
            currentEmail = user.email ?? "guest@prodify.com"
            await vm.fetchOrders(for: currentEmail)
            refreshID = UUID()
        }
    }

    // MARK: - Date formatter
    private func formatDate(from isoDate: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: isoDate) {
            return date.formatted(date: .abbreviated, time: .shortened)
        } else {
            return isoDate
        }
    }
}

