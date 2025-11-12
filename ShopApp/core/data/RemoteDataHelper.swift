//
//  RemoteDataHelper.swift
//  MovieApp
//
//  Created by mohamed ezz on 15/10/2025.
//

import Foundation

final class RemoteDataHelper: FetchDataProtocol {
    
    static let shared = RemoteDataHelper()
    private init() {}
    
    private var defaultHeaders: [String: String] {
        [
            "Content-Type": "application/json",
          //  "X-Shopify-Access-Token": ""
        ]
    }
    
    func fetchData<T: Decodable>(
        from baseURL: String,
        queryItems: [URLQueryItem] = []
    ) async throws -> T {
    
        guard var components = URLComponents(string: baseURL),
              let scheme = components.scheme, !scheme.isEmpty,
         
              (components.host != nil && !components.host!.isEmpty || components.path.hasPrefix("/")) else {
            throw NSError(domain: "InvalidURL", code: 400)
        }
        

        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        guard let finalURL = components.url else {
            throw NSError(domain: "InvalidURL", code: 400)
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        

        for (key, value) in defaultHeaders {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "HTTPError", code: 500)
        }
        
        if !(200...299).contains(httpResponse.statusCode) {
            throw NSError(domain: "HTTPError", code: httpResponse.statusCode)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }

}
