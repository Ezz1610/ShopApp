//
//  RemoteDataHelper.swift
//  MovieApp
//
//  Created by mohamed ezz on 15/10/2025.
//

import Foundation
//FIRST


final class RemoteDataHelper: FetchDataProtocol {
    
    static let shared = RemoteDataHelper()
    private init() {}
    
//    private let accessToken = "Admin API access token that in drive file or password that in postman"
    
    private var defaultHeaders: [String: String] {
        [
            "Content-Type": "application/json",
         "X-Shopify-Access-Token": ""
        ]
    }
    
    func fetchData<T: Decodable>(
        from baseURL: String,
        queryItems: [URLQueryItem] = []
    ) async throws -> T {
    
        var components = URLComponents(string: baseURL)
        components?.queryItems = queryItems
        
        guard let finalURL = components?.url else {
            throw NSError(domain: "InvalidURL", code: 400)
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        
        // Add default headers automatically
        for (key, value) in defaultHeaders {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse,
           !(200...299).contains(httpResponse.statusCode) {
            throw NSError(domain: "HTTPError", code: httpResponse.statusCode)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
