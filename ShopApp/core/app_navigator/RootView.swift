//
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
    var body: some View {
        NavigationStack {
            switch navigator.currentScreen {
            case .login:
                LoginScreen()

            case .register:
                RegisterScreen()

            case .mainTabView:
                MainTabView()
       //     case .testHome:
//              TestHomeScreen(context: context)

//            case .productsView:
//              ProductsView(context: context)
////
//            case .favoritesView:
//                FavoritesView(context: context)

            case .productDetails(let product):
                ProductDetailsView(product: product)
                    .environment(CartManager())
                    
                
            case .homeView:
                HomeView(context: context)
            }
        }
        .animation(.easeInOut, value: navigator.currentScreen)
    }
}
