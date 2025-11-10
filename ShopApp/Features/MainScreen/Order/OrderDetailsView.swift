//
//  DetailsOrder.swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 09/11/2025.
//
//import SwiftUI
//
//struct OrderDetailsView: View {
//    let order: ShopifyOrder
//
//    var body: some View {
//        List {
//            Section {
//                HStack {
//                    Text("Order #\(order.order_number)")
//                    Spacer()
//                    Text(ISO8601DateFormatter()
//                        .date(from: order.created_at!)?
//                        .formatted(date: .abbreviated, time: .shortened) ?? "")
//                    .foregroundColor(.secondary)
//                    .font(.caption)
//                }
//            }
//
//            Section("Items") {
//                ForEach(order.line_items.indices, id: \.self) { i in
//                    let it = order.line_items?[i]
//                    HStack {
//                        VStack(alignment: .leading) {
//                            Text(it.title)
//                            if it.quantity > 1 {
//                                Text("Qty: \(it.quantity)")
//                                    .font(.caption)
//                                    .foregroundColor(.secondary)
//                            }
//                        }
//                        Spacer()
//                        Text("\(it.price) \(order.currency)")
//                            .bold()
//                    }
//                }
//            }
//
//            Section {
//                HStack {
//                    Text("Total")
//                    Spacer()
//                    Text("\(order.current_total_price) \(order.currency)")
//                        .font(.headline)
//                }
//            }
//        }
//        .navigationTitle("Order Details")
//    }
//}
