//
//  SwiftUIView.swift
//  ShopApp
//
//  Created by Mohammed ezz on 24/10/2025.
//
import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(\.modelContext) private var context
    @State private var selectedTab: Int = 0

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
           ZStack(alignment: .bottom) {
               // MARK: - Main content
               Group {
                   switch selectedTab {
                   case 0:
                       HomeView(context: context)
                   case 1:
                       CategoriesView(context: context)
                   case 2:
                       CheckoutView()
                   default:
                       HomeView(context: context)
                   }
               }
               .frame(maxWidth: .infinity, maxHeight: .infinity)
               .background(Color(.systemBackground).ignoresSafeArea())
               
               // MARK: - Custom Capsule Tab Bar
               HStack(spacing: 40) {
                   TabBarButton(
                       icon: selectedTab == 0 ? "house.fill" : "house",
                       title: "Home",
                       selected: selectedTab == 0,
                       color: .green
                   ) {
                       withAnimation(.spring()) {
                           selectedTab = 0
                       }
                   }
                   
                   TabBarButton(
                       icon: selectedTab == 1 ? "square.grid.2x2.fill" : "square.grid.2x2",
                       title: "Categories",
                       selected: selectedTab == 1,
                       color: .green
                   ) {
                       withAnimation(.spring()) {
                           selectedTab = 1
                       }
                   }
                   
                   TabBarButton(
                       icon: selectedTab == 2 ? "gearshape.fill" : "gearshape",
                       title: "Settings",
                       selected: selectedTab == 2,
                       color: .green
                   ) {
                       withAnimation(.spring()) {
                           selectedTab = 2
                       }
                   }
               }
               .padding(.horizontal, 25)
               .padding(.vertical, 12)
               .background(.ultraThinMaterial.opacity(0.8))
               .clipShape(Capsule())
               .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 5)
               .padding(.horizontal, 40)
               .padding(.bottom, 10)
           }
           .tint(.green)
           .ignoresSafeArea(.keyboard, edges: .bottom)
       }
   }

   struct TabBarButton: View {
       let icon: String
       let title: String
       let selected: Bool
       let color: Color
       let action: () -> Void
       
       var body: some View {
           Button(action: action) {
               VStack(spacing: 4) {
                   Image(systemName: icon)
                       .font(.system(size: 18, weight: .semibold))
                       .foregroundColor(selected ? color : .gray)
                   Text(title)
                       .font(.system(size: 11, weight: .medium))
                       .foregroundColor(selected ? color : .gray)
               }
               .padding(.vertical, 6)
               .frame(maxWidth: .infinity)
           }
       }
   }
