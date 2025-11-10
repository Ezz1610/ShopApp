//
//  HelperFuctions.swift
//  WeatherApp
//
//  Created by mohamed ezz on 12/10/2025.
//

import Foundation


struct HelperFunctions {
    
    
    static func dayOfWeek(from dateString: String, index: Int = 0) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: dateString) {
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEE"
            
            if index == 0 {
                return "Today"
            } else {
                return dayFormatter.string(from: date)
            }
        }
        return ""
    }
    static func hourString(from dateString: String) -> String {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd HH:mm"
           if let date = formatter.date(from: dateString) {
               formatter.dateFormat = "ha" // e.g., "3PM"
               return formatter.string(from: date)
           }
           return ""
       }
//    static func setupDependencies() {
//            let locator = ServiceLocator.shared
//            
//            locator.register(FetchDataProtocol.self, RemoteDataHelper())
//            
//            let useCase = MovieListUseCase(dataHelper: locator.resolve(FetchDataProtocol.self))
//            locator.register(MovieListUseCaseProtocol.self, useCase)
//            
//            let viewModel = MovieViewModel(movieListUseCase: locator.resolve(MovieListUseCaseProtocol.self))
//            locator.register(MovieViewModel.self, viewModel)
//        }
    static func stringToDouble(_ value: String, defaultValue: Double = 0.0) -> Double {
        return Double(value) ?? defaultValue
    }
    static  func navigateFromToString(_ from: NavigateFrom) -> String {
        switch from {
        case .fromHome:
            return "Home"
        case .fromCategory:
            return "Categories"
        case .fromFavorites:
            return "Favorites"
        }
    }


}
