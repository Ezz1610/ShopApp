//
//  AppViewModel.swift
//  ShopApp
//
//  Created by mohamed ezz on 09/11/2025.
//



import Foundation
import SwiftUI
import FirebaseAuth

@MainActor
final class AppViewModel: ObservableObject {
    static let shared = AppViewModel()

    @Published var isLoading = true
    @Published var isLoggedIn = false
    @Published var isGuest = false

    var navigator: AppNavigator!

    private init() {}

    func setNavigator(_ navigator: AppNavigator) {
        self.navigator = navigator
        Task {
            await checkLoginStatus()
        }
    }

    func checkLoginStatus() async {
        isLoading = true
        defer { isLoading = false }

        try? await Task.sleep(nanoseconds: 1_000_000_000)

        if let user = Auth.auth().currentUser {
            print("User logged in: \(user.uid)")
            isLoggedIn = true
            navigator.goTo(.mainTabView(selectedTab: 0), replaceLast: false)
        } else {
            print("User not logged in")
            isLoggedIn = false
            navigator.goTo(.login, replaceLast: false)
        }
    }

    func handleLoginSuccess() {
        isLoggedIn = true
        isGuest = false
        navigator.goTo(.mainTabView(selectedTab: 0), replaceLast: false)
    }

    func handleLogout() {
        isLoggedIn = false
        isGuest = false
        navigator.goTo(.login, replaceLast: false)
    }
}
