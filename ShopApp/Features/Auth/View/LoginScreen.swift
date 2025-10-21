//
//  LoginScreen.swift
//  ShopApp
//
//  Created by mohamed ezz on 21/10/2025.
//
import Foundation
import SwiftUI

struct LoginScreen: View {
    @EnvironmentObject var navigator: AppNavigator
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?

    private var canLogin: Bool { !email.isEmpty && !password.isEmpty && !isLoading }

    var body: some View {
        VStack(spacing: 20) {
            Image("appicon")
                .resizable()
                .scaledToFit()
                .frame(width: 110, height: 110)
                .padding(.top, 30)

            Text(AppStrings.loginTitle)
                .font(.largeTitle)
                .fontWeight(.bold)

            VStack(spacing: 12) {
                CustomTextField(
                    iconName: "envelope",
                    placeholder: AppStrings.emailPlaceholder,
                    text: $email,
                    fieldType: .plain,
                    keyboardType: .emailAddress,
                    autocapitalization: .never,
                    submitLabel: .next,
                    onCommit: {},
                    isEmailField: true
                )

                CustomTextField(
                    iconName: "lock",
                    placeholder: AppStrings.passwordPlaceholder,
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
            }

            VStack(spacing: 12) {
                // Login button
                CustomButton(
                    title: AppStrings.loginButton,
                    action: attemptLogin,
                    enabled: canLogin
                )

                // Register button - outlined style
                CustomButton(
                    title: AppStrings.registerButton,
                    action: {
                        print("Navigating to RegisterScreen")
                        navigator.goTo(.register)
                    },
                    enabled: true,
                    background: .clear,
                    textColor: AppColors.primary,
                    borderColor: AppColors.primary
                )
            }
            .padding(.horizontal)

            Spacer()
        }
    }

    private func attemptLogin() {
        guard !isLoading else { return }
        errorMessage = nil

        // Validation example
        guard email.contains("@"), email.contains(".") else {
            errorMessage = "Please enter a valid email"
            return
        }
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            return
        }

        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isLoading = false
            // fake login success
//            navigator.goTo(.home)
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
