//
//  RegisterScreen.swift
//  ShopApp
//
//  Created by mohamed ezz on 21/10/2025.
//

import SwiftUI

struct RegisterScreen: View {
    @EnvironmentObject var navigator: AppNavigator

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @State private var errorMessage: String?

    // Focus state for fields
    enum Field: Hashable {
        case firstName, lastName, email, password, confirmPassword
    }
    @FocusState private var focusedField: Field?

    // Validation
    private var isEmailValid: Bool {
        email.contains("@") && email.contains(".")
    }

    private var canRegister: Bool {
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        !email.isEmpty &&
        isEmailValid &&
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        password == confirmPassword &&
        !isLoading
    }

    var body: some View {
        VStack(spacing: 20) {
            // Back Button
            HStack {
                Button(action: { navigator.goBack() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(AppColors.primary)
                        .font(.title2)
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 10)

            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 10)

            VStack(spacing: 12) {
                CustomTextField(
                    iconName: "person",
                    placeholder: "First Name",
                    text: $firstName,
                    fieldType: .plain,
                    keyboardType: .default,
                    autocapitalization: .words,
                    submitLabel: .next
                )
                .focused($focusedField, equals: .firstName)
                .onAppear { focusedField = .firstName } // أول ما الشاشة تظهر، الأول يبقى مفعل

                CustomTextField(
                    iconName: "person",
                    placeholder: "Last Name",
                    text: $lastName,
                    fieldType: .plain,
                    keyboardType: .default,
                    autocapitalization: .words,
                    submitLabel: .next
                )
                .focused($focusedField, equals: .lastName)

                CustomTextField(
                    iconName: "envelope",
                    placeholder: "Email",
                    text: $email,
                    fieldType: .plain,
                    keyboardType: .emailAddress,
                    autocapitalization: .none,
                    submitLabel: .next
                )
                .focused($focusedField, equals: .email)

                if !isEmailValid && !email.isEmpty {
                    Text("Please enter a valid email address")
                        .foregroundColor(.red)
                        .font(.footnote)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 4)
                }

                CustomTextField(
                    iconName: "lock",
                    placeholder: "Password",
                    text: $password,
                    fieldType: .secure,
                    keyboardType: .default,
                    autocapitalization: .none,
                    submitLabel: .next
                )
                .focused($focusedField, equals: .password)

                CustomTextField(
                    iconName: "lock",
                    placeholder: "Confirm Password",
                    text: $confirmPassword,
                    fieldType: .secure,
                    keyboardType: .default,
                    autocapitalization: .none,
                    submitLabel: .done,
                    onCommit: attemptRegister
                )
                .focused($focusedField, equals: .confirmPassword)
            }
            .padding(.horizontal)

            if let msg = errorMessage {
                Text(msg)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
            }

            CustomButton(
                title: "Register",
                action: attemptRegister,
                enabled: canRegister
            )
            .padding(.horizontal)

            Spacer()
        }
        .navigationBarHidden(true)
    }

    private func attemptRegister() {
        guard !isLoading else { return }
        errorMessage = nil

        guard isEmailValid else {
            errorMessage = "Invalid email address"
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }

        isLoading = true
        // API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isLoading = false
            navigator.goBack() // نرجع لل LoginScreen بعد التسجيل
        }
    }
}
