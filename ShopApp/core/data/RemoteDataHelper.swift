//
//  RemoteDataHelper.swift
//  MovieApp
//
//  Created by mohamed ezz on 15/10/2025.
//

import Foundation
final class RemoteDataHelper: FetchDataProtocol {
    func fetchData<T: Decodable>(
        from baseURL: String,
        queryItems: [URLQueryItem] = [],
        completionHandler: @escaping (Result<T, Error>) -> Void
    ) {
        var components = URLComponents(string: baseURL)
        components?.queryItems = queryItems
        
        guard let finalURL = components?.url else {
            completionHandler(.failure(NSError(domain: "InvalidURL", code: 400)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            guard let data = data else {
                completionHandler(.failure(NSError(domain: "NoData", code: 204)))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completionHandler(.success(decoded))
            } catch {
                completionHandler(.failure(error))
            }
        }
        task.resume()
    }
}
