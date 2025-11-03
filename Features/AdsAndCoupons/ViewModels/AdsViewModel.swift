//
//  AdsViewModel.swift
//  ShopApp
//
//  Created by Soha Elgaly on 21/10/2025.
//

import Foundation
import SwiftUI
 @MainActor
final class AdsViewModel: ObservableObject {
    @Published var ads: [AdItem] = []
    @Published var message: String?
    private let ruleID = 1185842102407
    private let apiService = ApiService()
    
    
    
    func loadAds() async {
        do {
            let codes = try await apiService.fetchDiscountCode(for: ruleID)
            let images = ["offer1","offer2","offer3"]
            self.ads = zip(images, codes).map{ (image, code) in
                AdItem(imageName: image, couponCode: code.code)
            }
        } catch  {
            message = "Failed To Fetch DiscountCodes: \(error.localizedDescription)"
        }
    }
    
    func copyCode(_ ad: AdItem) {
        UIPasteboard.general.string = ad.couponCode
        message = "Copied code \(ad.couponCode) successfully!"
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.message = nil
                }
    }
    
}
