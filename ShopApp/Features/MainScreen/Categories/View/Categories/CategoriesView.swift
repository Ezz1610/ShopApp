//
//  Catogries .swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 24/10/2025.
//
import SwiftUI
import SwiftData

struct CategoriesView: View {
    @EnvironmentObject var navigator: AppNavigator
    @Environment(\.modelContext) private var context
    @StateObject private var vm: CategoriesProductsViewModel
    @State private var selectedCategory: Category?

    private let gridCols = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    init(context: ModelContext) {
        _vm = StateObject(wrappedValue: CategoriesProductsViewModel(context: context))
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // Header
                    HomeHeaderView()
                        .padding(.top, 8)
                        .background(Color(.systemBackground))

                    VStack(alignment: .leading, spacing: 16) {

                        // CATEGORIES HORIZONTAL CHIPS
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(vm.categories) { cat in
                                    CategoryChip(
                                        category: cat,
                                        isSelected: cat.id == selectedCategory?.id,
                                        onTap: {
                                            selectedCategory = cat
                                            Task { await vm.loadProducts(for: cat) }
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 4)
                        }

                        // PRODUCTS GRID / STATES
                        VStack {
                            if vm.isLoading && vm.products.isEmpty {
                                ProgressView("Loading products…")
                                    .padding(.horizontal, 16)

                            } else if let err = vm.errorMessage,
                                      vm.products.isEmpty {
                                Text("Error: \(err)")
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 16)

                            } else if vm.filteredProducts.isEmpty {
                                Text("No products match your filters.")
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 16)

                            } else {
                                LazyVGrid(
                                    columns: gridCols,
                                    alignment: .leading,
                                    spacing: 16
                                ) {
                                    ForEach(vm.filteredProducts) { product in
                                        ProductCardView(product: product, viewModel: vm)
                                            .frame(maxWidth: .infinity)
                                            .onTapGesture {
                                                navigator.goTo(.productDetails(product))
                                            }
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.bottom, 32)
                            }
                        }
                    }
                }
                .background(Color(.systemGray6))
            }
            .background(Color(.systemGray6))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar)
            .task {
                if vm.categories.isEmpty {
                    await vm.loadCategories()
                }
            }
            .onChange(of: vm.categories.count) { _ in
                if selectedCategory == nil,
                   let first = vm.categories.first {
                    selectedCategory = first
                    Task { await vm.loadProducts(for: first) }
                }
            }
        }
    }
}

// MARK: - Bottom sheet with icons (Shoes / Accessories)
struct IconMultiSelectSheet: View {
    @Binding var chosenGroups: Set<String>
    let onApply: (Set<String>) -> Void

   
    private let groupsMeta: [(key: String, label: String, systemImage: String)] = [
        ("shoes",        "Shoes",               "shoeprints.fill"),
        ("accessories",  "Bags & Accessories",  "bag.fill")
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                Spacer().frame(height: 8)

                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 24),
                        GridItem(.flexible(), spacing: 24)
                    ],
                    alignment: .center,
                    spacing: 32
                ) {
                    ForEach(groupsMeta, id: \.key) { item in
                        let isOn = chosenGroups.contains(item.key)

                        Button {
                            toggle(item.key)
                        } label: {
                            VStack(spacing: 10) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .fill(isOn ? Color.black : Color.white)
                                        .frame(width: 100, height: 100)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                .stroke(
                                                    isOn ? Color.black : Color.gray.opacity(0.3),
                                                    lineWidth: 1
                                                )
                                        )
                                        .shadow(
                                            color: .black.opacity(isOn ? 0.18 : 0.07),
                                            radius: 8, x: 0, y: 4
                                        )

                                    Image(systemName: item.systemImage)
                                        .font(.system(size: 30, weight: .semibold))
                                        .foregroundColor(isOn ? .white : .primary)
                                }

                                Text(item.label)
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)

                Button {
                    // clear all
                    chosenGroups.removeAll()
                } label: {
                    Text("Show all products")
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(.blue)
                }
                .padding(.top, 4)

                Spacer(minLength: 0)

                Button {
                    onApply(chosenGroups)
                } label: {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.black)
                        .frame(height: 52)
                        .overlay(
                            Text("Apply")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                        )
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 24)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func toggle(_ key: String) {
        if chosenGroups.contains(key) {
            chosenGroups.remove(key)
        } else {
            chosenGroups.insert(key)
        }
    }
}
