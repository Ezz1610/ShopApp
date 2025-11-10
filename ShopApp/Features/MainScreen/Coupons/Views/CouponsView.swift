//
//  AdsScreen.swift
//  ShopApp
//
//  Created by Soha Elgaly on 21/10/2025.
//

import SwiftUI

struct CouponsView: View {
    @StateObject private var vm = CouponsViewModel()

    var body: some View {
        ZStack {
            VStack {
                if vm.ads.isEmpty {
                    ProgressView("Loading...")
                        
                } else {
                    TabView {
                        ForEach(vm.ads) { ad in
                            ZStack(alignment: .bottom) {
                                // Background Image
                                Image(ad.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 200)
                                    .frame(maxWidth: .infinity)
                                    .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                                    .overlay(
                                        // Gradient overlay for readability
                                        LinearGradient(
                                            gradient: Gradient(colors: [.black.opacity(0.3), .clear]),
                                            startPoint: .bottom,
                                            endPoint: .top
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                                    )
                                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 6)
                                    .padding(.horizontal)
                                    .padding(.vertical, 10)
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            vm.copyCode(ad)
                                        }
                                    }
                                
                                // Text overlay
                                VStack(spacing: 6) {
                                    Text("Tap to copy code 🤩")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .shadow(radius: 3)
                                        .padding(.bottom, 12)
                                }
                                .padding(.bottom, 20)
                            }
                        }
                    }
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    .frame(height: 250)
                    .animation(.easeInOut, value: vm.ads.count)
                }
            }
            .task {
                await vm.loadAds()
            }

            // ✅ Floating message (Toast)
            if let message = vm.message {
                VStack {
                    Spacer()
                    Text(message)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.black.opacity(0.9), Color.black.opacity(0.7)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
                        )
                        .padding(.top, 60)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: vm.message)
                        .onAppear {
                            // Auto-hide after 2 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation(.easeOut(duration: 0.5)) {
                                    vm.message = nil
                                }
                            }
                        }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: vm.message)
    }
}
