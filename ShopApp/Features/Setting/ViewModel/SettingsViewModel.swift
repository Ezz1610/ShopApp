//
//  SettingsViewModel.swift
//  ShopApp
//
//  Created by Soha Elgaly on 23/10/2025.
//

import SwiftUI
import Combine
import FirebaseAuth

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var location = "Unknown"
    @Published var selectedCurrency = "EGP"
    @Published var defaultAddress: String?

  
    private var cancellables = Set<AnyCancellable>()
    private let firebaseHelper = FirebaseHelper.shared
    
    init() {

        Task {
            await fetchUserData()
        }
    }
    
  
    func fetchUserData() async {
        do {
            if let userData = try await firebaseHelper.getUserData() {
                await MainActor.run {
                    let firstName = userData["firstName"] as? String ?? ""
                    let lastName = userData["lastName"] as? String ?? ""
                    self.username = "\(firstName) \(lastName)"
                    self.email = userData["email"] as? String ?? ""
                }
            } else {
                print("No user data found.")
            }
        } catch {
            print("Error fetching user data: \(error.localizedDescription)")
        }
    }
    func logout(navigator: AppNavigator) {
        do {
            try Auth.auth().signOut()
            navigator.replaceStack(with: .login)
            print("User logged out successfully")
        } catch {
            print("Error logging out: \(error.localizedDescription)")
        }
    }

}
