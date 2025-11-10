//
//  ApiServicesTests.swift
//  ShopAppTests
//
//  Created by Mohammed Hassanien on 10/11/2025.
//



import XCTest
@testable import ShopApp

final class ApiServicesTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Register the mock protocol globally so URLSession.shared requests are intercepted.
        URLProtocol.registerClass(MockURLProtocol.self)
        MockURLProtocol.requestHandler = nil
    }

    override func tearDown() {
        MockURLProtocol.requestHandler = nil
        URLProtocol.unregisterClass(MockURLProtocol.self)
        super.tearDown()
    }

    // Helper to create an HTTPURLResponse with given status code for a request url.
    private func httpResponse(for request: URLRequest, statusCode: Int = 200) -> HTTPURLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: "HTTP/1.1", headerFields: nil)!
    }

    func testFetchProductsReturnsDecodedProducts() async throws {
        let json = """
        {
          "products": [
            { "id": 1, "title": "One", "vendor": "ACME", "price": "10.0", "variants": [{"price":"10.0"}], "image": {"src":"img1"} },
            { "id": 2, "title": "Two", "vendor": "ACME2", "price": "20.0", "variants": [{"price":"20.0"}], "image": {"src":"img2"} }
          ]
        }
        """
        MockURLProtocol.requestHandler = { request in
            // Assert method and headers automatically added in RemoteDataHelper
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
            let response = self.httpResponse(for: request, statusCode: 200)
            return (response, Data(json.utf8))
        }

        let api = ApiServices()
        let products = try await api.fetchProducts()
        XCTAssertEqual(products.count, 2)
        XCTAssertTrue(products.contains { $0.id == 1 })
        XCTAssertTrue(products.contains { $0.id == 2 })
    }

    func testFetchVendorsReturnsUniqueSortedVendors() async throws {
        let json = """
        {
          "products": [
            { "id": 1, "vendor": "Zeta" },
            { "id": 2, "vendor": "alpha" },
            { "id": 3, "vendor": "Zeta" }
          ]
        }
        """
        MockURLProtocol.requestHandler = { request in
            let response = self.httpResponse(for: request, statusCode: 200)
            return (response, Data(json.utf8))
        }

        let api = ApiServices()
        let vendors = try await api.fetchVendors()
        // Should be unique and sorted (case-insensitive sorting produced by Array(sorted()))
        XCTAssertEqual(vendors.sorted(by: { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }), vendors)
        XCTAssertEqual(Set(vendors).count, vendors.count)
        XCTAssertTrue(vendors.contains("Zeta"))
        XCTAssertTrue(vendors.contains("alpha"))
    }

    func testFetchProductsByVendorFiltersCorrectly() async throws {
        let json = """
        {
          "products": [
            { "id": 1, "vendor": "TargetVendor" },
            { "id": 2, "vendor": "OtherVendor" },
            { "id": 3, "vendor": "TargetVendor" }
          ]
        }
        """
        MockURLProtocol.requestHandler = { request in
            let response = self.httpResponse(for: request, statusCode: 200)
            return (response, Data(json.utf8))
        }

        let api = ApiServices()
        let filtered = try await api.fetchProducts(byVendor: "TargetVendor")
        XCTAssertEqual(filtered.count, 2)
        XCTAssertTrue(filtered.allSatisfy { $0.vendor.caseInsensitiveCompare("TargetVendor") == .orderedSame })
    }

    func testFetchProducts_forCollectionID_minus1_usesLimit250() async throws {
        // For collectionID == -1, ApiServices should call fetchAllProducts(limit: 250)
        MockURLProtocol.requestHandler = { request in
            XCTAssertTrue(request.url?.absoluteString.contains("limit=250") ?? false)
            let json = """
            { "products": [ { "id": 11, "vendor": "V1" } ] }
            """
            let response = self.httpResponse(for: request, statusCode: 200)
            return (response, Data(json.utf8))
        }

        let api = ApiServices()
        let products = try await api.fetchProducts(for: -1)
        XCTAssertEqual(products.count, 1)
        XCTAssertEqual(products.first?.id, 11)
    }

    func testFetchProducts_forCollectionID_fetchesCollectsThenProducts() async throws {
        // Simulate two-step flow: /collects.json?collection_id=XX -> returns collects,
        // then /products.json?ids=... -> returns matching products.
        var callIndex = 0
        MockURLProtocol.requestHandler = { request in
            callIndex += 1
            let url = request.url!.absoluteString
            if url.contains("/collects.json") {
                let collectsJson = """
                { "collects": [ { "product_id": 100 }, { "product_id": 200 } ] }
                """
                return (self.httpResponse(for: request, statusCode: 200), Data(collectsJson.utf8))
            } else if url.contains("/products.json") && url.contains("ids=") {
                XCTAssertTrue(url.contains("100") && url.contains("200"))
                let productsJson = """
                { "products": [ { "id": 100, "vendor": "V" }, { "id": 200, "vendor": "V" } ] }
                """
                return (self.httpResponse(for: request, statusCode: 200), Data(productsJson.utf8))
            } else {
                XCTFail("Unexpected URL: \(url)")
                return (self.httpResponse(for: request, statusCode: 500), nil)
            }
        }

        let api = ApiServices()
        let products = try await api.fetchProducts(for: 555)
        XCTAssertEqual(products.count, 2)
        XCTAssertTrue(products.contains { $0.id == 100 })
        XCTAssertTrue(products.contains { $0.id == 200 })
        XCTAssertGreaterThanOrEqual(callIndex, 2)
    }

    func testFetchDiscountCodes_parsesResponse() async throws {
        let json = """
        {
          "discount_codes": [
            { "code": "SAVE10", "id": 1 },
            { "code": "HALF", "id": 2 }
          ]
        }
        """
        MockURLProtocol.requestHandler = { request in
            XCTAssertTrue(request.url!.absoluteString.contains("/price_rules/123/discount_codes.json"))
            return (self.httpResponse(for: request, statusCode: 200), Data(json.utf8))
        }

        let api = ApiServices()
        let codes = try await api.fetchDiscountCodes(for: 123)
        XCTAssertEqual(codes.count, 2)
        XCTAssertTrue(codes.contains { $0.code == "SAVE10" })
    }

    func testFetchSmartCollections_parsesResponse() async throws {
        let json = """
        { "smart_collections": [ { "id": 9, "title": "Best" } ] }
        """
        MockURLProtocol.requestHandler = { request in
            XCTAssertTrue(request.url!.absoluteString.contains("/smart_collections.json"))
            return (self.httpResponse(for: request, statusCode: 200), Data(json.utf8))
        }

        let api = ApiServices()
        let collections = try await api.fetchSmartCollections()
        XCTAssertEqual(collections.count, 1)
        XCTAssertEqual(collections.first?.id, 9)
    }

    func testFetchProductsByCollectionID_logsAndReturnsProducts() async throws {
        let json = """
        { "products": [ { "id": 77, "vendor": "V" } ] }
        """
        MockURLProtocol.requestHandler = { request in
            XCTAssertTrue(request.url!.absoluteString.contains("/collections/777/products.json"))
            return (self.httpResponse(for: request, statusCode: 200), Data(json.utf8))
        }

        let api = ApiServices()
        let products = try await api.fetchProductsByCollectionID(777)
        XCTAssertEqual(products.count, 1)
        XCTAssertEqual(products.first?.id, 77)
    }

    // MARK: - RemoteDataHelper direct error branches

    func testRemoteDataHelperThrowsInvalidURLForBadBase() async throws {
        // Call with an invalid base that cannot produce a URL from URLComponents.
        do {
            let _: String = try await RemoteDataHelper.shared.fetchData(from: ":::")
            XCTFail("Expected to throw InvalidURL, but succeeded")
        } catch let error as NSError {
            XCTAssertEqual(error.domain, "InvalidURL")
            XCTAssertEqual(error.code, 400)
        }
    }

    func testRemoteDataHelperThrowsHTTPErrorOnNon2xx() async throws {
        let json = """
        { "any": "value" }
        """
        MockURLProtocol.requestHandler = { request in
            return (self.httpResponse(for: request, statusCode: 500), Data(json.utf8))
        }

        do {
            // Use a decodable type that matches the JSON structure so decoding would succeed if status was 200.
            let _: [String: String] = try await RemoteDataHelper.shared.fetchData(from: "https://example.com/test.json")
            XCTFail("Expected HTTPError to be thrown")
        } catch let error as NSError {
            XCTAssertEqual(error.domain, "HTTPError")
            XCTAssertEqual(error.code, 500)
        }
    }
}
