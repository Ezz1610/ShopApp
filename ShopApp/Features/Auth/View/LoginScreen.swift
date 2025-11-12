//
//  LoginScreen.swift
//  ShopApp
//
//  Created by mohamed ezz on 21/10/2025.
//


import SwiftUI


struct LoginScreen: View {
    @EnvironmentObject var navigator: AppNavigator
    @StateObject private var viewModel = LoginViewModel()

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
                emailField
                passwordField
            }
            .padding(.horizontal)

            if viewModel.showAlert {
                Text(viewModel.alertMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: 12) {
                loginButton
                
                Button("Don't have an account? click here to create one.") {
                    navigator.goTo(.register, replaceLast: false)
                }
                .font(.footnote)
                .padding(.top, 8)
                .foregroundStyle(AppColors.primary)

                // ===== Add Continue as Guest button =====
                Button("Continue as Guest") {
                    AppViewModel.shared.isGuest = true
                    AppViewModel.shared.isLoggedIn = false
                    navigator.goTo(.mainTabView(selectedTab: 0), replaceLast: true)
                }
                .font(.footnote)
                .padding(.top, 8)
                .foregroundColor(AppColors.primary)
            }
            .padding(.horizontal)

            Spacer()
        }
        .disabled(viewModel.isLoading)
    }

    private func attemptLogin() {
        Task {
            let success = await viewModel.login()
            if success {
                AppViewModel.shared.isGuest  = false
                navigator.goTo(.mainTabView(selectedTab: 0), replaceLast: true)
            }
        }
    }

    private var emailField: some View {
        CustomTextField(
            iconName: "envelope",
            placeholder: AppStrings.emailPlaceholder,
            text: $viewModel.email,
            fieldType: .plain,
            keyboardType: .emailAddress,
            autocapitalization: .never,
            submitLabel: .next,
            onCommit: {},
            isEmailField: true
        )
    }

    private var passwordField: some View {
        CustomTextField(
            iconName: "lock",
            placeholder: AppStrings.passwordPlaceholder,
            text: $viewModel.password,
            fieldType: .secure,
            keyboardType: .default,
            autocapitalization: .never,
            submitLabel: .done,
            onCommit: attemptLogin
        )
    }

    private var loginButton: some View {
        CustomButton(
            title: AppStrings.loginButton,
            action: attemptLogin,
            enabled: viewModel.canLogin
        )
    }
    
    
}
