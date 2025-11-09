//FIRST
//  AppNavigator.swift
//  ShopApp
//
//  Created by mohamed ezz on 21/10/2025.
//
import Foundation
import SwiftUI

final class AppNavigator: ObservableObject {
    @Published private(set) var screenStack: [Screen] = [.mainTabView]
    

    enum Screen: Equatable {
        static func == (lhs: AppNavigator.Screen, rhs: AppNavigator.Screen) -> Bool {
            switch (lhs, rhs) {
            case (.login, .login),
                (.register, .register),
              //  (.testHome, .testHome),
                (.homeView, .homeView):
              //  (.productsView, .productsView):
                // (.favoritesView, .favoritesView):
                return true
                
            case (.productDetails(let a), .productDetails(let b)):
                return a.id == b.id
                
            default:
                return false
            }
        }

        case login
        case register
        case mainTabView
        case homeView
        case cartView
       // case testHome
        //case productsView
        case favoritesView
        case productDetails(ProductModel)
    }

    var currentScreen: Screen {
        screenStack.last ?? .login
    }

    func goTo(_ screen: Screen) {
        screenStack.append(screen)
    }

    func goBack() {
        guard screenStack.count > 1 else { return }
        screenStack.removeLast()
    }

    func popToRoot() {
        screenStack = [screenStack.first].compactMap { $0 }
    }
}
