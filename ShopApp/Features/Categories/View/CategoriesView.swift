
//
//  Catogries .swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 24/10/2025.
//
import SwiftUI
import SwiftData


@MainActor
struct CategoriesView: View {
    @EnvironmentObject var navigator: AppNavigator
    @StateObject private var viewModel: HomeViewModel
    @State private var selectedCategoryID: Int? = nil
    @State private var showFilterSheet = false
    @State private var tempGroups: Set<String> = []
    private let productColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    init(context: ModelContext) {
        HomeViewModel.initializeSingleton(context: context)
        _viewModel = StateObject(wrappedValue: HomeViewModel.shared)
    }

    var body: some View {
       
            VStack(spacing: 0) {
                HomeHeaderView()
                    .padding(.top, 8)
                    .background(Color(.systemBackground))

                HStack(spacing: 8) {
                                HStack(spacing: 8) {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                    TextField("Search products...", text: $viewModel.searchText)
                                        .textInputAutocapitalization(.never)
                                        .disableAutocorrection(true)
                                }
                                .padding(10)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)

                                Button {
                                    tempGroups = viewModel.currentChosenGroups()
                                    showFilterSheet = true
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(Color.black.opacity(0.05))
                                        Image(systemName: "line.3.horizontal.decrease.circle")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(.black.opacity(0.7))
                                    }
                                    .frame(width: 44, height: 44)
                                }
                                .buttonStyle(.plain)
                                
                            }
                            .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(viewModel.categories, id: \.id) { category in
                            Button {
                                withAnimation(.easeInOut) {
                                    selectedCategoryID = category.id
                                }
                                Task {
                                    if category.id == -1 || category.title.lowercased() == "all" {
                                        await viewModel.loadProducts()
                                    } else {
                                        viewModel.updateProductsForCollection(category)
                                    }
                                }
                            } label: {
                                Text(category.title)
                                    .font(.system(size: 14, weight: .semibold))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        Capsule()
                                            .fill(selectedCategoryID == category.id ? .black : .white)
                                            .overlay(
                                                Capsule()
                                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                            )
                                    )
                                    .foregroundColor(selectedCategoryID == category.id ? .white : .primary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                }

                Divider().padding(.horizontal, 8)

                ScrollView {
                    if viewModel.isLoading {
                        ProgressView("Products are loading...")
                            .frame(maxWidth: .infinity)
                            .padding(.top, 50)
                    } else if let error = viewModel.errorMessage {
                        Text(" Error : \(error)")
                            .foregroundColor(.red)
                            .padding()
                    } else if viewModel.filteredProducts.isEmpty {
                           Text("Products are not available now")
                            .foregroundColor(.gray)
                            .padding(.top, 50)
                    } else {
                        LazyVGrid(columns: productColumns, spacing: 16) {
                            ForEach(viewModel.filteredProducts, id: \.id) { product in
                                ProductCardView(product: product, viewModel: viewModel)
                                    .onTapGesture {
                                        navigator.goTo(.productDetails(product , NavigateFrom.fromCategory), replaceLast: false)
                                    }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    }
                }
            }
            .background(Color(.systemGray6))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar)
            .task {
                if viewModel.categories.isEmpty {
                    await viewModel.loadCategories()
                }

                if selectedCategoryID == nil {
                    selectedCategoryID = -1
                    await viewModel.loadProducts()
                }

                await viewModel.refreshFavorites()
            }
                .sheet(isPresented: $showFilterSheet) {
                    IconMultiSelectSheet(
                        chosenGroups: $tempGroups,
                        onApply: { groups in
                            viewModel.applyGroups(groups)
                            showFilterSheet = false
                        }
                    )
                }
               
            
    }
}
// MARK: - Bottom sheet with icons (Shoes / Accessories)
struct IconMultiSelectSheet: View {
    @Binding var chosenGroups: Set<String>
    let onApply: (Set<String>) -> Void

   
    private let groupsMeta: [(key: String, label: String, systemImage: String)] = [
        ("shoes",        "Shoes",               "shoeprints.fill"),
        ("accessories",  "Bags & Accessories",  "bag.fill"),
        ("tshirts",      "T-Shirts",            "tshirt.fill")

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
