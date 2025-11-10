//FIRST
//  AppNavigator.swift
//  ShopApp
//
//  Created by mohamed ezz on 21/10/2025.
//
import Foundation
import SwiftUI

@MainActor
final class AppNavigator: ObservableObject {
    // MARK: - Properties
    @Published private(set) var screenStack: [Screen] = []
    @Published private var isNavigatingBack = false

    // MARK: - Screen Enum
    enum Screen: Equatable {
        case splash
        case login
        case register
        case mainTabView(selectedTab: Int = 0)
        case homeView
        case cartView
        case favoritesView
        case brandProducts(brand: SmartCollection, homeVM: HomeViewModel) // ✅ أضفنا الحالة الجديدة
        case productDetails(ProductModel, NavigateFrom)
        case ordersView
        case addressesView
        case addAddress
        case listAddresses
        case checkoutView
        static func == (lhs: Screen, rhs: Screen) -> Bool {
            switch (lhs, rhs) {
            case (.splash, .splash),
                 (.login, .login),
                 (.register, .register),
                 (.homeView, .homeView),
                 (.cartView, .cartView),
                 (.favoritesView, .favoritesView),
                (.ordersView, .ordersView):
                return true

            case (.mainTabView(let a), .mainTabView(let b)):
                return a == b

            case (.productDetails(let productA, let fromA),
                  .productDetails(let productB, let fromB)):
                return productA.id == productB.id && fromA == fromB
                
            case (.brandProducts(let a, _), .brandProducts(let b, _)):
                           return a.id == b.id

            default:
                return false
            }
        }
    }

    // MARK: - Current Screen
    var currentScreen: Screen {
        screenStack.last ?? .splash
    }

    // MARK: - Navigation Methods
    func goTo(_ screen: Screen, replaceLast: Bool = false) {
        withAnimation(.easeInOut) {
            if replaceLast, !screenStack.isEmpty {
                screenStack[screenStack.count - 1] = screen
            } else {
                screenStack.append(screen)
            }
        }
    }

    func goBack() {
        guard !isNavigatingBack, screenStack.count > 1 else { return }

        isNavigatingBack = true
        withAnimation(.easeInOut) {
            screenStack.removeLast()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isNavigatingBack = false
        }
    }

    func popToRoot() {
        guard let first = screenStack.first else { return }
        withAnimation(.easeInOut) {
            screenStack = [first]
        }
    }

    func replaceStack(with screen: Screen) {
        withAnimation(.easeInOut) {
            screenStack = [screen]
        }
    }
}
