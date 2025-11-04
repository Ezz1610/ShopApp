//
//  AppTextStyle.swift
//  WeatherApp
//
//  Created by mohamed ezz on 12/10/2025.
//
import SwiftUI


struct AppTextStyle {
    static let mainFont: String = "YourCustomFontName"
    
    static func customStyle(
        fontSize: CGFloat,
        weight: Font.Weight = .regular,
        color: Color = .primary,
        lineHeight: CGFloat? = nil
    ) -> some ViewModifier {
        return CustomTextStyle(fontSize: fontSize, weight: weight, color: color, lineHeight: lineHeight)
    }

    static func mediumStyle(
         fontSize: CGFloat = 12,
         color: Color = .primary,
         lineHeight: CGFloat? = nil
     ) -> some ViewModifier {
         customStyle(fontSize: fontSize, weight: .medium, color: color, lineHeight: lineHeight)
     }

     static func semiboldStyle(
         fontSize: CGFloat = 12,
         color: Color = .primary,
         lineHeight: CGFloat? = nil
     ) -> some ViewModifier {
         customStyle(fontSize: fontSize, weight: .semibold, color: color, lineHeight: lineHeight)
     }

    static func regularStyle(fontSize: CGFloat = 12, color: Color = .primary, lineHeight: CGFloat? = nil) -> some ViewModifier {
        customStyle(fontSize: fontSize, weight: .regular, color: color, lineHeight: lineHeight)
    }

    static func boldStyle(fontSize: CGFloat = 12, color: Color = .primary, lineHeight: CGFloat? = nil) -> some ViewModifier {
        customStyle(fontSize: fontSize, weight: .heavy, color: color, lineHeight: lineHeight)
    }
}
