//
//  ViewModel.swift
//  ShopApp
//
//  Created by mohamed ezz on 21/10/2025.
//

import Foundation
import Combine



@MainActor
final class RegisterViewModel: ObservableObject {
    private let firebaseHelper: FirebaseHelper
    
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    init(firebaseHelper: FirebaseHelper = .shared) {
        self.firebaseHelper = firebaseHelper
    }
    
    var canRegister: Bool {
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        isValidEmail(email) &&
        !password.isEmpty &&
        password == confirmPassword &&
        !isLoading
    }
    
    func register() {
        guard canRegister else {
            showAlert(title: "Error", message: "Please fill all fields correctly.")
            return
        }
        
        isLoading = true
        print("🟡 [RegisterViewModel] Starting registration...")

        Task {
            do {
                try await firebaseHelper.register(
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    password: password
                )
                
                isLoading = false
                showAlert(title: "Success", message: "Verification email sent. Please check your inbox.")
                
            } catch {
                isLoading = false
                showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let regex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }

    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}
