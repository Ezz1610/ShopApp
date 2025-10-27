//
//  HomeHeaderSection.swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 23/10/2025.
//

import SwiftUI



struct BrandProductsView: View {
    let vendor: String
    @StateObject private var vm: BrandProductsViewModel

    init(vendor: String) {
        self.vendor = vendor
        _vm = StateObject(wrappedValue: BrandProductsViewModel(vendor: vendor))
    }

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ScrollView {
            if vm.products.isEmpty && !vm.isLoading {
                VStack(spacing: 12) {
                    Image(systemName: "shippingbox")
                        .font(.largeTitle)
                        .foregroundColor(.gray)

                    Text("No products found for \(vendor)")
                        .foregroundColor(.gray)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                }
                .padding(.top, 100)
                .frame(maxWidth: .infinity)
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(vm.products) { product in
                        ProductCardView(product: product)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
        }
        .background(Color(.systemGray6))
        .navigationTitle(vendor)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.white, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.light, for: .navigationBar)
        .task {
            await vm.load()
        }
        .overlay {
            if vm.isLoading {
                ProgressView()
                    .scaleEffect(1.3)
            }
        }
    }
}
