//
//  SplashScreen.swift
//  ShopApp
//
//  Created by mohamed ezz on 09/11/2025.
//

import Foundation
import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                Image("appicon") // replace with your logo asset
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                Text("ShopApp")
                    .font(.largeTitle.bold())
                    .foregroundColor(.black)
            }
        }
    }
}
