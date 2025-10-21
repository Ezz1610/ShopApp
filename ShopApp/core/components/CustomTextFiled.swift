//
//  CustomTextFiled.swift
//  ShopApp
//
//  Created by mohamed ezz on 21/10/2025.
//

import Foundation
import SwiftUI

struct CustomTextField: View {
    enum FieldType {
        case plain
        case secure
    }
    
    let iconName: String?
    let placeholder: String
    @Binding var text: String
    var fieldType: FieldType = .plain
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: TextInputAutocapitalization? = .never
    var submitLabel: SubmitLabel = .done
    var onCommit: (() -> Void)? = nil
    
    var height: CGFloat = 48
    var cornerRadius: CGFloat = 12
    
    @State private var isSecured: Bool = true
    
    var body: some View {
        HStack(spacing: 12) {
            if let iconName = iconName {
                Image(systemName: iconName)
                    .foregroundColor(.secondary)
                    .frame(width: 22, height: 22)
            }
            
            Group {
                if fieldType == .secure {
                    if isSecured {
                        SecureField(placeholder, text: $text)
                            .textInputAutocapitalization(autocapitalization)
                            .keyboardType(keyboardType)
                            .submitLabel(submitLabel)
                            .onSubmit {
                                onCommit?()
                            }
                    } else {
                        TextField(placeholder, text: $text)
                            .textInputAutocapitalization(autocapitalization)
                            .keyboardType(keyboardType)
                            .submitLabel(submitLabel)
                            .onSubmit {
                                onCommit?()
                            }
                    }
                } else {
                    TextField(placeholder, text: $text)
                        .textInputAutocapitalization(autocapitalization)
                        .keyboardType(keyboardType)
                        .submitLabel(submitLabel)
                        .onSubmit {
                            onCommit?()
                        }
                }
            }
            .disableAutocorrection(true)
            
            if fieldType == .secure {
                Button(action: { isSecured.toggle() }) {
                    Image(systemName: isSecured ? "eye.slash" : "eye")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(isSecured ? "Show password" : "Hide password")
            }
        }
        .padding(.horizontal, 12)
        .frame(height: height)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color(.quaternaryLabel), lineWidth: 0.5)
        )
    }
}
