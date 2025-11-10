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
    @Published var isDarkMode = false
    @Published var defaultAddress: String?

    let currencies = ["USD", "EGP", "EUR", "SAR"]
    private var cancellables = Set<AnyCancellable>()
    private let locationManager = LocationManager.shared
    private let firebaseHelper = FirebaseHelper.shared
    
    init() {
        locationManager.$currentCity
            .receive(on: RunLoop.main)
            .sink { [weak self] city in
                if !city.isEmpty {
                    self?.location = city
                }
            }
            .store(in: &cancellables)
        
        Task {
            await fetchUserData()
        }
    }
    
    func requestUserLocation() {
        locationManager.requestLocationPermission()
    }
    
    func toggleTheme() {
        isDarkMode.toggle()
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
            try Auth.auth().signOut()  // 👈 ده اللي بيعمل تسجيل خروج من Firebase فعلاً
            navigator.replaceStack(with: .login) // 👈 نرجع لشاشة اللوجين
            print("🚪 User logged out successfully")
        } catch {
            print("❌ Error logging out: \(error.localizedDescription)")
        }
    }

}
