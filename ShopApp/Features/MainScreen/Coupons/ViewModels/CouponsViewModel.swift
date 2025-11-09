//
//  AdsViewModel.swift
//  ShopApp
//
//  Created by Soha Elgaly on 21/10/2025.
//


import Foundation
import SwiftUI

@MainActor
final class CouponsViewModel: ObservableObject {
    
    @Published var ads: [AdItem] = []
    @Published var message: String?
    @Published var isLoading: Bool = false
    
    private let apiService = ApiServices()
    private let ruleID: Int
    
    init(ruleID: Int = 1185842102407) {
        self.ruleID = ruleID
    }
    
    func loadAds() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let codes = try await apiService.fetchDiscountCodes(for: ruleID)
            
            let images = ["offer1", "offer2", "offer3"]
            self.ads = zip(images, codes).map { image, code in
                AdItem(imageName: image, couponCode: code.code)
            }
            
           // message = "discount codes loaded successfully "
            
        } catch {
            message = "failed to fetch discount codes: \(error.localizedDescription)"
        }
    }
    
    func copyCode(_ ad: AdItem) {
        UIPasteboard.general.string = ad.couponCode
        message = "Copied successfully!"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.message = nil
        }
    }
}
