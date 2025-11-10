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
    @StateObject private var appVM: AppViewModel
    
    init(navigator: AppNavigator) {
        _appVM = StateObject(wrappedValue: AppViewModel(navigator: navigator))
    }
    
    var body: some View {
        ZStack {
            if appVM.isLoading {
                SplashScreenView()
            } else {
                NavigationStack {
                    switch navigator.currentScreen {
                    case .login:
                        LoginScreen()
                        
                    case .register:
                        RegisterScreen()
                        
                    case .cartView:
                        CartView()
                            .environmentObject(CartManager.shared)
                        
                    case .mainTabView:
                        MainTabView()
                            .environmentObject(CartManager.shared)
                        
                    case .favoritesView:
                        FavoritesView(context: context)
                            .environmentObject(CartManager.shared)
                        
                    case .productDetails(let product):
                        ProductDetailsView(product: product)
                            .environmentObject(CartManager.shared)
                        
                    case .homeView:
                        HomeView(context: context)
                            .environmentObject(CartManager.shared)
                    case .splash:
                       SplashScreenView()
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
