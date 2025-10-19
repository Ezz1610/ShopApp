//
//  File.swift
//  MovieApp
//
//  Created by mohamed ezz on 15/10/2025.
//

import Foundation

final class ServiceLocator {
    static let shared = ServiceLocator()
    
    private var  services : [String : Any] = [:]
    private init () {}
    
    func register<T>(_ type: T.Type, _ service: T) {
        let key = "\(type)"
        services[key] = service
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        let key = "\(T.self)"
         
        guard let service  = services[key] as? T else {
            fatalError("service not registered")
        }
        return service
    }
}
