//
//  CustomViewAlert.swift
//  ShopApp
//
//  Created by mohamed ezz on 22/10/2025.
//

import Foundation
import SwiftUI

struct CustomAlertView: View {
    let title: String
    let message: String
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 16) {
                Text(title)
                    .font(.headline)
                    .bold()

                Text(message)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)

                Button(action: onDismiss) {
                    Text("OK")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColors.primary)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 8)
            .padding(.horizontal, 40)
        }
        .transition(.opacity)
        .animation(.easeInOut, value: title)
    }
}
