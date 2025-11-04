//
//  FetchDataProtocol.swift
//  WeatherApp
//
//  Created by mohamed ezz on 12/10/2025.
//

import Foundation
protocol FetchDataProtocol {
    func fetchData<T: Decodable>(
        from baseURL: String,
        queryItems: [URLQueryItem]
    ) async throws -> T
}
