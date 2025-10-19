//
//  File.swift
//  MovieApp
//
//  Created by mohamed ezz on 19/10/2025.
//

import Foundation
import SwiftUI

struct AppColors {
    static let primary = Color(hex: "#202053")
    static let hint = Color.gray
    static let white = Color.white


    static let grey = Color.gray
    static let red = Color.red
    static let green = Color.green
    static let orange = Color.orange
    static let black = Color.black
    static let screenBackground = Color(hex: "#1A1D3A")
    static let movieItemBackground = Color(hex: "#23274A")
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}
