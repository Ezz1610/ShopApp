
import Foundation
struct ProductsResponse: Decodable {
    let products: [ProductModel]
}

struct ProductModel: Decodable, Identifiable {
    let id: Int
    let title, bodyHTML, vendor, productType: String
    let createdAt, updatedAt, publishedAt: String
    let handle: String
    let templateSuffix: String
    let publishedScope, tags, status, adminGraphqlAPIID: String
    let variants: [Variant]
    let options: [ProductOption]
    let images: [ProductImage]
    let image: ProductImage?

    enum CodingKeys: String, CodingKey {
        case id, title
        case bodyHTML = "body_html"
        case vendor
        case productType = "product_type"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case publishedAt = "published_at"
        case handle
        case templateSuffix = "template_suffix"
        case publishedScope = "published_scope"
        case tags, status
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case variants, options, images, image
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)

        id = try c.decodeIfPresent(Int.self, forKey: .id) ?? 0
        title = try c.decodeIfPresent(String.self, forKey: .title) ?? ""
        bodyHTML = try c.decodeIfPresent(String.self, forKey: .bodyHTML) ?? ""
        vendor = try c.decodeIfPresent(String.self, forKey: .vendor) ?? ""
        productType = try c.decodeIfPresent(String.self, forKey: .productType) ?? ""
        createdAt = try c.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        updatedAt = try c.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
        publishedAt = try c.decodeIfPresent(String.self, forKey: .publishedAt) ?? ""
        handle = try c.decodeIfPresent(String.self, forKey: .handle) ?? ""
        templateSuffix = try c.decodeIfPresent(String.self, forKey: .templateSuffix) ?? ""
        publishedScope = try c.decodeIfPresent(String.self, forKey: .publishedScope) ?? ""
        tags = try c.decodeIfPresent(String.self, forKey: .tags) ?? ""
        status = try c.decodeIfPresent(String.self, forKey: .status) ?? ""
        adminGraphqlAPIID = try c.decodeIfPresent(String.self, forKey: .adminGraphqlAPIID) ?? ""
        variants = try c.decodeIfPresent([Variant].self, forKey: .variants) ?? []
        options = try c.decodeIfPresent([ProductOption].self, forKey: .options) ?? []
        images = try c.decodeIfPresent([ProductImage].self, forKey: .images) ?? []
        image = try c.decodeIfPresent(ProductImage.self, forKey: .image) ?? nil
    }
}
