//FIRST
//  AppNavigator.swift
//  ShopApp
//
//  Created by mohamed ezz on 21/10/2025.
//
import Foundation
import SwiftUI


@MainActor
final class AppNavigator: ObservableObject {
    // بدل ما نبدأ بـ mainTabView مباشرة، نبدأ فاضي، والسكرين بيتحدد بعد السبلاتش
    @Published private(set) var screenStack: [Screen] = []
    
    // Enum فيه كل الشاشات بتاعة الأب
    enum Screen: Equatable {
        case splash
        case login
        case register
        case mainTabView
        case homeView
        case cartView
        case favoritesView
        case productDetails(ProductModel)
        case ordersView
        
        static func == (lhs: Screen, rhs: Screen) -> Bool {
            switch (lhs, rhs) {
            case (.splash, .splash),
                 (.login, .login),
                 (.register, .register),
                 (.mainTabView, .mainTabView),
                 (.homeView, .homeView),
                 (.cartView, .cartView),
                 (.favoritesView, .favoritesView),
                (.ordersView, .ordersView):
                return true
                
            case (.productDetails(let a), .productDetails(let b)):
                return a.id == b.id
                
            default:
                return false
            }
        }
    }
    
    // الشاشة الحالية
    var currentScreen: Screen {
        screenStack.last ?? .splash
    }
    
    // الانتقال لشاشة جديدة
    func goTo(_ screen: Screen, replaceLast: Bool) {
        withAnimation(.easeInOut) {
            if replaceLast, !screenStack.isEmpty {
                screenStack[screenStack.count - 1] = screen
            } else {
                screenStack.append(screen)
            }
        }
    }
//    func goTo(_ screen: Screen) {
//        withAnimation(.easeInOut) {
//            screenStack.append(screen)
//        }
//    }
//    
    // رجوع شاشة واحدة
    @Published private var isNavigatingBack = false

        func goBack() {
            guard !isNavigatingBack else { return }
            guard screenStack.count > 1 else { return }

            isNavigatingBack = true
            withAnimation(.easeInOut) {
                screenStack.removeLast()
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.isNavigatingBack = false
            }
        }
//    func goBack() {
//        guard screenStack.count > 1 else { return }
//        withAnimation(.easeInOut) {
//            screenStack.removeLast()
//        }
//    }
    
    // رجوع لأول شاشة في الستاك (root)
    func popToRoot() {
        guard let first = screenStack.first else { return }
        withAnimation(.easeInOut) {
            screenStack = [first]
        }
    }
    
    // إعادة توجيه (مثلاً لو عايز تنقل المستخدم من login لـ main بعد ما يعمل login)
    func replaceStack(with screen: Screen) {
        withAnimation(.easeInOut) {
            screenStack = [screen]
        }
    }
}
