//
//  ViewModel.swift
//  ShopApp
//
//  Created by mohamed ezz on 21/10/2025.
//

import Foundation
import Combine


final class RegisterViewModel: ObservableObject {
    // MARK: - Dependencies
    private let firebaseHelper: FirebaseHelper
    
    // MARK: - Input Fields
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    // MARK: - UI State
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    // MARK: - Init with Dependency Injection
    init(firebaseHelper: FirebaseHelper = .shared) {
        self.firebaseHelper = firebaseHelper
    }
    
    // MARK: - Computed Properties
    var canRegister: Bool {
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        isValidEmail(email) &&
        !password.isEmpty &&
        password == confirmPassword &&
        !isLoading
    }
    
    // MARK: - Public Methods
    func register() {
        guard canRegister else {
            showAlert(title: "Error", message: "Please fill all fields correctly.")
            return
        }
        
        isLoading = true
        print("🟡 [RegisterViewModel] Starting registration...")
        
        firebaseHelper.register(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success:
                    self.showAlert(title: "Success", message: "Verification email sent. Please check your inbox.")
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Private Helpers
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
