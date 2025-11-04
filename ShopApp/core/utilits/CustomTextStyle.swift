//
//  CustomTextStyle.swift
//  WeatherApp
//
//  Created by mohamed ezz on 12/10/2025.
//

import SwiftUI

struct CustomTextStyle: ViewModifier {
    var fontSize: CGFloat
    var weight: Font.Weight
    var color: Color
    var lineHeight: CGFloat?

    func body(content: Content) -> some View {
        content
            .font(.system(size: fontSize, weight: weight))
            .foregroundColor(color)
            .lineSpacing(lineHeight ?? 0)
    }
}
