//
//  customButton.swift
//  ShopApp
//
//  Created by mohamed ezz on 21/10/2025.
//

import Foundation
import SwiftUI
//struct CustomButton: View {
//    let title: String
//    let action: () -> Void
//    var enabled: Bool = true
//    
//    var body: some View {
//        Button(action: action) {
//            Text(title)
//                .fontWeight(.semibold)
//                .frame(maxWidth: .infinity)
//                .frame(height: 48)
//        }
//        .disabled(!enabled)
//        .background(enabled ? AppColors.primary : AppColors.primary.opacity(0.4))
//        .foregroundColor(.white)
//        .cornerRadius(12)
//        .opacity(enabled ? 1.0 : 0.9)
//    }
//}
//
//struct SecondaryButton: View {
//    let title: String
//    let action: () -> Void
//    var body: some View {
//        Button(action: action) {
//            Text(title)
//                .fontWeight(.semibold)
//                .frame(maxWidth: .infinity)
//                .frame(height: 44)
//        }
//        .foregroundColor(.accentColor)
//        .background(
//            RoundedRectangle(cornerRadius: 12)
//                .stroke(Color.accentColor, lineWidth: 1)
//                .background(Color.clear)
//        )
//    }
//}
struct CustomButton: View {
    let title: String
    let action: () -> Void
    var enabled: Bool = false
    
    // Totally dynamic attributes:
    var background: Color = AppColors.primary
    var textColor: Color = .white
    var borderColor: Color? = nil
    var cornerRadius: CGFloat = 12
    var height: CGFloat = 48
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .foregroundColor(textColor)
        }
        .disabled(!enabled)
        .background(enabled ? background : background.opacity(0.4))
        .overlay(
            borderColor != nil ?
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor!, lineWidth: 1)
            : nil
        )
        .cornerRadius(cornerRadius)
        .opacity(enabled ? 1.0 : 0.9)
    }
}
