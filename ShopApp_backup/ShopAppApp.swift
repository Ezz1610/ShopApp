//
//  ShopAppApp.swift
//  ShopApp
//
//  Created by mohamed ezz on 19/10/2025.
//



import SwiftUI
import FirebaseCore
import SwiftData

@main
struct ShopAppApp: App {
    @StateObject private var navigator = AppNavigator()
    @State var cartManager = CartManager()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ProductModel.self,
            Variant.self,
            ProductImage.self,
            ProductOption.self
        ])
        
        let config = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        return try! ModelContainer(for: schema, configurations: [config])
    }()
    
    init() {
        FirebaseApp.configure()
        print("Firebase configured.")
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(navigator)
                .environment(cartManager)
                .modelContainer(sharedModelContainer)
        }
    }
}
