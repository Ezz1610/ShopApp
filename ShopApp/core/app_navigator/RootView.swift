////FIRST

//  File.swift
//  ShopApp
//
//  Created by mohamed ezz on 21/10/2025.
//



import Foundation
import SwiftUI

struct RootView: View {
    @EnvironmentObject var navigator: AppNavigator
    @Environment(\.modelContext) private var context
    @StateObject private var appVM = AppViewModel.shared


    var body: some View {
        ZStack {
            if appVM.isLoading {
                SplashScreenView()
            } else {
                NavigationStack {
                    switch navigator.currentScreen {
                    case .splash:
                        SplashScreenView()

                    case .login:
                        LoginScreen()

                    case .register:
                        RegisterScreen()
                        
                    case .addressesView:
                        AddressesListView()

                    case .cartView:
                        CartView()
                            .environmentObject(CartManager.shared)

                    case .mainTabView(let selectedTab):
                        MainTabView(selectedTab: selectedTab)
                            .environmentObject(CartManager.shared)

                    case .favoritesView:
                        FavoritesView(context: context)
                            .environmentObject(CartManager.shared)

                    case .homeView:
                        HomeView(context: context)
                            .environmentObject(CartManager.shared)

                    case .productDetails(let product, let navigateFrom):
                        ProductDetailsView(product: product, navigateFrom: navigateFrom)
                            .environmentObject(CartManager.shared)

                    case .brandProducts(let brand , let homeVM):
                        BrandProductsView(brand: brand, homeVM: homeVM)
                            .environmentObject(CartManager.shared)

                    case .ordersView:
                        OrderView()
                    case .addAddress:
                        AddAddressView()
                    case .listAddresses:
                        AddressesListView()
                    case .checkoutView:
                        CheckoutView()
                   
                    }
                }
                .animation(.easeInOut, value: navigator.currentScreen)
                .task {
                    SwiftDataHelper.shared(context: context)
                    print("SwiftDataHelper initialized with persistent context")
                }
            }
        }
    }
}
