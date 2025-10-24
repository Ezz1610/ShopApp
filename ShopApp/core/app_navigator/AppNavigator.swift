//
//  AppNavigator.swift
//  ShopApp
//
//  Created by mohamed ezz on 21/10/2025.
//


import Foundation
import SwiftUI

final class AppNavigator: ObservableObject {
    @Published private(set) var screenStack: [Screen] = [.testHome]

    enum Screen: Equatable {
        case login
        case register
        case testHome
        case productsView
        // case home
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
