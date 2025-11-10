
//
//  FirebaseHelper.swift
//  ShopApp
//
//  Created by mohamed ezz on 21/10/2025.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

@MainActor
final class FirebaseHelper {
    static let shared = FirebaseHelper()
    private init() {}

    private let db = Firestore.firestore()

    // MARK: - Register
    func register(
        firstName: String,
        lastName: String,
        email: String,
        password: String
    ) async throws {
        print("🟢 FirebaseHelper Register started for \(email)")

        guard FirebaseApp.app() != nil else {
            throw NSError(
                domain: "FirebaseHelper",
                code: -10,
                userInfo: [NSLocalizedDescriptionKey: "Firebase not configured properly."]
            )
        }

        // 1️⃣ إنشاء المستخدم في Firebase Auth
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let user = authResult.user
        print("✅ User created with UID:", user.uid)

        // 2️⃣ حفظ بيانات المستخدم في Firestore
        let userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "createdAt": FieldValue.serverTimestamp()
        ]

        try await db.collection("users").document(user.uid).setData(userData)
        print("📦 User data saved successfully to Firestore.")

        // 3️⃣ إرسال إيميل التحقق
        try await user.sendEmailVerification()
        print("📧 Verification email sent to \(email).")
    }

    // MARK: - Login
    func login(email: String, password: String) async throws -> Bool {
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return authResult.user.isEmailVerified
    }

    // MARK: - Get User Data
    func getUserData() async throws -> [String: Any]? {
        guard let user = Auth.auth().currentUser else {
            print("⚠️ No user is currently logged in.")
            return nil
        }

        let document = try await db.collection("users").document(user.uid).getDocument()

        guard let data = document.data() else {
            print("⚠️ User data not found for UID:", user.uid)
            return nil
        }

        print("📥 User data fetched successfully:", data)
        return data
    }

    // MARK: - Logout
    func logout() throws {
        try Auth.auth().signOut()
    }

    // MARK: - Current User
    func currentUser() -> User? {
        Auth.auth().currentUser
    }
}
