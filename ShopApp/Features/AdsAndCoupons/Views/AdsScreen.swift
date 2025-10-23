//
//  AdsScreen.swift
//  ShopApp
//
//  Created by Soha Elgaly on 21/10/2025.
//

import SwiftUI

struct AdsScreen: View {
    @StateObject private var vm = AdsViewModel()

    var body: some View {
        VStack {
            if vm.ads.isEmpty {
                ProgressView("Loading...")
                    
            } else {
                TabView {
                    ForEach(vm.ads) { ad in
                        
                        VStack {
                            Image(ad.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 180)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(radius: 20)
                                .padding(.horizontal, 10)
                                .onTapGesture {
                                    vm.copyCode(ad)
                                }
                                Text("Tap to copy code")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding(.bottom, 12)
                            
                        }
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
               
            }
            if let message = vm.message {
                Text(message)
                    .foregroundColor(.green)
                    .padding(.top)
                    .transition(.opacity)
            }
        }.task {
            await vm.loadAds()
        }
        .animation(.easeInOut(duration: 0.2), value: vm.message)
    }
}

#Preview {
    AdsScreen()
}
