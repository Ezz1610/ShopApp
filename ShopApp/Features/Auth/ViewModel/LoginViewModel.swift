//
//  LoginViewModel.swift
//  ShopApp
//
//  Created by mohamed ezz on 22/10/2025.
//


import Foundation
import Combine
import FirebaseAuth

final class LoginViewModel: ObservableObject {
    // MARK: - Dependencies
    private let firebaseHelper: FirebaseHelper
    
    // MARK: - Input Fields
    @Published var email = ""
    @Published var password = ""
    
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
    var canLogin: Bool {
        !email.isEmpty && !password.isEmpty && !isLoading
    }
    
    // MARK: - Public Methods
    func login(completion: @escaping (Bool) -> Void) {
        guard canLogin else {
            showAlert(title: "Error", message: "Please fill all fields correctly.")
            completion(false)
            return
        }
        
        guard isValidEmail(email) else {
            showAlert(title: "Error", message: "Please enter a valid email.")
            completion(false)
            return
        }
        
        guard password.count >= 6 else {
            showAlert(title: "Error", message: "Password must be at least 6 characters.")
            completion(false)
            return
        }
        
        isLoading = true
        print("🟡 [LoginViewModel] Starting login...")
        
        firebaseHelper.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let isVerified):
                    if isVerified {
                        completion(true) // Login success
                    } else {
                        self.showAlert(title: "Error", message: "Email not verified. Please check your inbox.")
                        completion(false)
                    }
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    completion(false)
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
