//
//  ShopAppApp.swift
//  ShopApp
//
//  Created by mohamed ezz on 19/10/2025.
//

import SwiftUI

@main
struct ShopAppApp: App {
@StateObject private var navigator = AppNavigator()

var body: some Scene {
WindowGroup {
RootView()
.environmentObject(navigator)
}
}
}
