//
//  SwiftUIView.swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 24/10/2025.
//
import SwiftUI

struct MainTabView: View {

    @State private var selectedTab: Int = 0
    @Environment(\.modelContext) private var context

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        appearance.shadowColor = UIColor.black.withAlphaComponent(0.1)

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().unselectedItemTintColor = UIColor.systemGray3
    }

    var body: some View {
        TabView(selection: $selectedTab) {

            HomeView(context: context)
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Home")
                            .font(.system(size: 11, weight: .medium))
                    }
                }
                .tag(0)

            CategoriesView(context: context)
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 1 ? "square.grid.2x2.fill" : "square.grid.2x2")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Categories")
                            .font(.system(size: 11, weight: .medium))
                    }
                }
                .tag(1)
        //ME SECTION
//                .tabItem {
//                    VStack {
//                        Image(systemName: selectedTab == 2 ? "person.fill" : "person")
//                            .font(.system(size: 18, weight: .semibold))
//                        Text("Me")
//                            .font(.system(size: 11, weight: .medium))
//                    }
//                }
//                .tag(2)
             CartView()
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 2 ? "cart.fill" : "cart")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Shopping Cart")
                            .font(.system(size: 11, weight: .medium))
                    }
                }
                .tag(2)
        }
        .tint(.green)
    }
}


