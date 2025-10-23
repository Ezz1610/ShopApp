//
//  FirebaseHelper.swift
//  ShopApp
//
//  Created by mohamed ezz on 21/10/2025.
//


import Foundation
import FirebaseAuth
import FirebaseCore

final class FirebaseHelper {
    static let shared = FirebaseHelper()
    private init() {}

    func register(
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        print(" FirebaseHelper Register started for \(email)")

        guard FirebaseApp.app() != nil else {
            let err = NSError(domain: "FirebaseHelper", code: -10,
                              userInfo: [NSLocalizedDescriptionKey: "Firebase not configured properly."])
            print("FirebaseApp not configured.")
            completion(.failure(err))
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Auth Error:", error.localizedDescription)
                completion(.failure(error))
                return
            }

            guard let user = authResult?.user else {
                completion(.failure(NSError(domain: "FirebaseHelper", code: 0,
                                            userInfo: [NSLocalizedDescriptionKey: "user creation failed."])))
                return
            }

            print("firebase Auth user created with UID:", user.uid)

            user.sendEmailVerification { emailError in
                if let emailError = emailError {
                    print("email verification failed:", emailError.localizedDescription)
                    completion(.failure(emailError))
                } else {
                    print("verification email sent successfully to \(email).")
                    completion(.success(()))
                }
            }
        }
    }

    func login(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                let isVerified = authResult?.user.isEmailVerified ?? false
                completion(.success(isVerified))
            }
        }
    }

    func logout() throws {
        try Auth.auth().signOut()
    }

    func currentUser() -> User? {
        Auth.auth().currentUser
    }
}
