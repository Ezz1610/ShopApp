//
//  LoadingView.swift
//  ShopApp
//
//  Created by mohamed ezz on 22/10/2025.
//

import Foundation
import SwiftUI

import SwiftUI

struct LoadingView: View {
    @Binding var isLoading: Bool
    var message: String = "Please wait..."

    var body: some View {
        if isLoading {
            ZStack {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 12) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(2)

                    Text(message)
                        .foregroundColor(.white)
                        .font(.headline)
                }
            }
            .transition(.opacity)
            .animation(.easeInOut, value: isLoading)
        }
    }
}

