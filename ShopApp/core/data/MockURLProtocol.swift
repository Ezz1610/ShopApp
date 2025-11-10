//
//  MockURLProtocol.swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 10/11/2025.
//
//
//  MockURLProtocol.swift
//  ShopAppTests
//
//  Created by Copilot on 2025-11-10.
//
//

import Foundation

final class MockURLProtocol: URLProtocol {
    /// Test sets this closure to handle every intercepted request.
    /// Return a tuple (HTTPURLResponse, Data?) or throw an error.
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?

    override class func canInit(with request: URLRequest) -> Bool {
        // Intercept everything during tests.
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            let error = NSError(domain: "MockURLProtocol", code: 0, userInfo: [NSLocalizedDescriptionKey: "No handler set"])
            client?.urlProtocol(self, didFailWithError: error)
            return
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {
        // Nothing to clean up for the mock.
    }
}
