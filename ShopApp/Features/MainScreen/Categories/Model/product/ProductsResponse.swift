import Foundation
import SwiftData
//FIRST



// MARK: - Response Wrapper
struct ProductsResponse: Decodable {
    let products: [ProductModel]
}

// MARK: - Product Model
@Model
final class ProductModel: Identifiable, Codable {
    @Attribute(.unique) var id: Int
    var title: String
    var bodyHTML: String
    var vendor: String
    var productType: String
    var createdAt: String
    var updatedAt: String
    var publishedAt: String
    var handle: String
    var templateSuffix: String
    var publishedScope: String
    var tags: String
    var status: String
    var adminGraphqlAPIID: String
    
    // السعر اللي هيتخزن فعلاً في SwiftData
    var price: String
    
    // الصورة اللي هتتحفظ
    var productImage: String

    // MARK: - Transient (مش محفوظ)
    @Transient var variants: [Variant] = []
    @Transient var options: [ProductOption] = []
    @Transient var images: [ProductImage] = []
    @Transient var image: ProductImage? = nil

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
        case price
        case productImage
    }

    // MARK: - Init
    init(
        id: Int = 0,
        title: String = "",
        bodyHTML: String = "",
        vendor: String = "",
        productType: String = "",
        createdAt: String = "",
        updatedAt: String = "",
        publishedAt: String = "",
        handle: String = "",
        templateSuffix: String = "",
        publishedScope: String = "",
        tags: String = "",
        status: String = "",
        adminGraphqlAPIID: String = "",
        price: String = "",
        productImage: String = "",
        variants: [Variant] = [],
        options: [ProductOption] = [],
        images: [ProductImage] = [],
        image: ProductImage? = nil
    ) {
        self.id = id
        self.title = title
        self.bodyHTML = bodyHTML
        self.vendor = vendor
        self.productType = productType
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.publishedAt = publishedAt
        self.handle = handle
        self.templateSuffix = templateSuffix
        self.publishedScope = publishedScope
        self.tags = tags
        self.status = status
        self.adminGraphqlAPIID = adminGraphqlAPIID
        self.price = price
        self.productImage = productImage
        self.variants = variants
        self.options = options
        self.images = images
        self.image = image
    }

    // MARK: - Codable
    required init(from decoder: Decoder) throws {
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
        image = try c.decodeIfPresent(ProductImage.self, forKey: .image)
        
        // السعر والصورة
        price = try c.decodeIfPresent(String.self, forKey: .price) ?? variants.first?.price ?? ""
        productImage = try c.decodeIfPresent(String.self, forKey: .productImage) ?? images.first?.src ?? ""
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(title, forKey: .title)
        try c.encode(bodyHTML, forKey: .bodyHTML)
        try c.encode(vendor, forKey: .vendor)
        try c.encode(productType, forKey: .productType)
        try c.encode(createdAt, forKey: .createdAt)
        try c.encode(updatedAt, forKey: .updatedAt)
        try c.encode(publishedAt, forKey: .publishedAt)
        try c.encode(handle, forKey: .handle)
        try c.encode(templateSuffix, forKey: .templateSuffix)
        try c.encode(publishedScope, forKey: .publishedScope)
        try c.encode(tags, forKey: .tags)
        try c.encode(status, forKey: .status)
        try c.encode(adminGraphqlAPIID, forKey: .adminGraphqlAPIID)
        try c.encode(variants, forKey: .variants)
        try c.encode(options, forKey: .options)
        try c.encode(images, forKey: .images)
        try c.encode(image, forKey: .image)
        try c.encode(price, forKey: .price)
        try c.encode(productImage, forKey: .productImage)
    }
}

// MARK: - Extensions
extension ProductModel {
    var validPrice: Double {
        if let mainPrice = Double(price), mainPrice > 0 {
            return mainPrice
        }
        if let variantPrice = Double(variants.first?.price ?? "0"), variantPrice > 0 {
            return variantPrice
        }
        return 0.0
    }
}
