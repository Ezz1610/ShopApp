//
//  RemoteDataHelper.swift
//  MovieApp
//
//  Created by mohamed ezz on 15/10/2025.
//


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
      "X-Shopify-Access-Token": "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"
        ]
    }
    
    func fetchData<T: Decodable>(
        from baseURL: String,
        queryItems: [URLQueryItem] = []
    ) async throws -> T {
    
        // Parse the incoming string into URLComponents first and validate.
        // This ensures obviously-bad strings like ":::"
        // will be rejected with InvalidURL before any network call.
        guard var components = URLComponents(string: baseURL),
              let scheme = components.scheme, !scheme.isEmpty,
              // require either host (normal absolute URL) or a path starting with "/" (rare, but we expect absolute URLs in tests)
              (components.host != nil && !components.host!.isEmpty || components.path.hasPrefix("/")) else {
            throw NSError(domain: "InvalidURL", code: 400)
        }
        
        // If caller provided explicit query items, merge/replace them.
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        guard let finalURL = components.url else {
            throw NSError(domain: "InvalidURL", code: 400)
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        
        // Add default headers automatically (use setValue to ensure single value for header)
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
