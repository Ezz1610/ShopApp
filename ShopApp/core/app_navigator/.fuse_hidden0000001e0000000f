//
//  AppNavigator.swift
//  ShopApp
//
//  Created by mohamed ezz on 21/10/2025.
//

import Foundation
import SwiftUI

final class AppNavigator: ObservableObject {
@Published var currentScreen: Screen = .login

enum Screen: Equatable {
case login
case register
//case home
}

func goTo(_ screen: Screen) {
currentScreen = screen
}

func goBack() {
currentScreen = .login
}
}
