//
//  LoginScreen.swift
//  ShopApp
//
//  Created by mohamed ezz on 21/10/2025.
//

import Foundation
struct LoginScreen: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    private var isEmailValid: Bool {
        return email.contains("@") && email.contains(".")
    }
    private var isPasswordValid: Bool { password.count >= 6 }
    private var canLogin: Bool { isEmailValid && isPasswordValid && !isLoading }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
//                Image(systemName: "lock.shield")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 110, height: 110)
//                    .padding(.top, 30)
//                    .foregroundColor(.accentColor)
                
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 6)
                
                VStack(spacing: 12) {
                    CustomTextField(
                        iconName: "envelope",
                        placeholder: "Email",
                        text: $email,
                        fieldType: .plain,
                        keyboardType: .emailAddress,
                        autocapitalization: .never,
                        submitLabel: .next,
                        onCommit: { /* focus next if using FocusState */ }
                    )
                    CustomTextField(
                        iconName: "lock",
                        placeholder: "Password",
                        text: $password,
                        fieldType: .secure,
                        keyboardType: .default,
                        autocapitalization: .never,
                        submitLabel: .done,
                        onCommit: { attemptLogin() }
                    )
                }
                .padding(.horizontal)
                
                if let msg = errorMessage {
                    Text(msg)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                // Buttons
                VStack(spacing: 12) {
                    PrimaryButton(title: isLoading ? "Logging in..." : "Login", action: attemptLogin, enabled: canLogin)
                    SecondaryButton(title: "Register", action: { /* present register screen */ })
                }
                .padding(.horizontal)
                .padding(.top, 6)
                
                Spacer()
            }
            .navigationBarHidden(true)
            .padding(.bottom, 20)
        }
    }
    
    private func attemptLogin() {
     
        guard !isLoading else { return }
        errorMessage = nil
        
        guard isEmailValid else {
            errorMessage = "Please enter a valid email address."
            return
        }
        guard isPasswordValid else {
            errorMessage = "Password must be at least 6 characters."
            return
        }
        
        isLoading = true
        // Simulate network delay (replace with real networking)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isLoading = false
            // fake success - in real app validate server response.
            // on success: navigate / store token / etc.
            // on failure: set errorMessage with server error string.
            let success = Bool.random()
            if success {
                print("logged in (simulate). Email:", email)
                errorMessage = nil
            } else {
                errorMessage = "invalid credentials or server error."
            }
        }
    }
}

//// MARK: - Previews
//struct LoginScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            LoginScreen()
//                .preferredColorScheme(.light)
//            LoginScreen()
//                .preferredColorScheme(.dark)
//        }
//    }
//}
