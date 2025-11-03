//
//  LoginViewModel.swift
//  ShopApp
//
//  Created by mohamed ezz on 22/10/2025.
//

import Foundation
import Combine
import FirebaseAuth

@MainActor
final class LoginViewModel: ObservableObject {
    private let firebaseHelper: FirebaseHelper
    
    @Published var email = ""
    @Published var password = ""
    
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    init(firebaseHelper: FirebaseHelper = .shared) {
        self.firebaseHelper = firebaseHelper
    }
    
    var canLogin: Bool {
        !email.isEmpty && !password.isEmpty && !isLoading
    }
    
    func login() async -> Bool {
        guard canLogin else {
            showAlert(title: "Error", message: "Please fill all fields correctly.")
            return false
        }
        
        guard isValidEmail(email) else {
            showAlert(title: "Error", message: "Please enter a valid email.")
            return false
        }
        
        guard password.count >= 6 else {
            showAlert(title: "Error", message: "Password must be at least 6 characters.")
            return false
        }
        
        isLoading = true
        print("[LoginViewModel] Starting login...")
        
        do {
            let isVerified = try await firebaseHelper.login(email: email, password: password)
            isLoading = false
            
            if isVerified {
                return true
            } else {
                showAlert(title: "Error", message: "Email not verified. Please check your inbox.")
                return false
            }
        } catch {
            isLoading = false
            showAlert(title: "Error", message: error.localizedDescription)
            return false
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}
