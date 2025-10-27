//
//  HomeView.swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 23/10/2025.
import SwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()
    @State private var searchText: String = ""

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {

                    HomeHeaderView()
                        .padding(.top, 8)

                    VStack(alignment: .leading, spacing: 20) {

                        HomeSearchBar(searchText: $searchText)

                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.07), radius: 8, x: 0, y: 4)

                            AdsScreen()
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                        .frame(height: 250)
                        .padding(.horizontal, 16)

                        BrandCollectionView(brands: vm.brands)
                    }
                    .padding(.bottom, 24)
                }
                .background(Color(.systemGray6))
            }
            .background(Color(.systemGray6))
            .navigationBarHidden(true)
            .task {
                await vm.load()
            }
        }
    }
}

#Preview {
    HomeView()
}
