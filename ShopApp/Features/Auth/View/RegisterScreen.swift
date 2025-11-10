//
//  RegisterScreen.swift
//  ShopApp
//
//  Created by mohamed ezz on 21/10/2025.
//
import SwiftUI

struct RegisterScreen: View {
    @EnvironmentObject var navigator: AppNavigator
    @StateObject private var viewModel = RegisterViewModel()

    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 18) {

                headerView
                firstNameField
                lastNameField
                emailField
                passwordField
                confirmPasswordField
                registerButton

                Spacer()
            }
            .padding(.horizontal)
            .disabled(viewModel.isLoading)

            LoadingView(isLoading: $viewModel.isLoading, message: "Please wait...")

            if viewModel.showAlert {
                CustomAlertView(
                    title: viewModel.alertTitle,
                    message: viewModel.alertMessage,
                    onDismiss: {
                        viewModel.showAlert = false
                        if viewModel.alertTitle == "Success" {
                            navigator.goTo(.login, replaceLast: false)
                        }
                    }
                )
            }
        }
    }

    private func attemptRegister() {
        Task {
            await viewModel.register()
        }
    }


    private var headerView: some View {
        VStack(spacing: 12) {
            HStack {
                Button(action: { navigator.goBack() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(AppColors.primary)
                        .padding(.top, 8)
                }
                Spacer()
            }

            Image("appicon")
                .resizable()
                .scaledToFit()
                .frame(width: 110, height: 110)
                .padding(.top, 30)

            Text("Create Account")
                .font(.largeTitle)
                .bold()
                .padding(.top, 4)
        }
    }

    private var firstNameField: some View {
        CustomTextField(
            iconName: "person",
            placeholder: "First Name",
            text: $viewModel.firstName,
            autoFocus: true
        )
    }

    private var lastNameField: some View {
        CustomTextField(
            iconName: "person",
            placeholder: "Last Name",
            text: $viewModel.lastName
        )
    }

    private var emailField: some View {
        CustomTextField(
            iconName: "envelope",
            placeholder: "Email",
            text: $viewModel.email,
            isEmailField: true
        )
    }

    private var passwordField: some View {
        CustomTextField(
            iconName: "lock",
            placeholder: "Password",
            text: $viewModel.password,
            fieldType: .secure
        )
    }

    private var confirmPasswordField: some View {
        CustomTextField(
            iconName: "lock",
            placeholder: "Confirm Password",
            text: $viewModel.confirmPassword,
            fieldType: .secure
        )
    }

    private var registerButton: some View {
        CustomButton(
            title: viewModel.isLoading ? "Registering..." : "Register",
            action: attemptRegister,
            enabled: viewModel.canRegister && !viewModel.isLoading
        )
    }
}
