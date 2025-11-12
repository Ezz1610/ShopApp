//
//  SwiftUIView.swift
//  MovieApp
//
//  Created by mohamed ezz on 19/10/2025.
//

import SwiftUI

struct StarRatingView: View {
    let rating: Double
    let size: Double

    init(rating: Double, size: Double = 15) {
        self.rating = rating
        self.size = size
    }

    private let totalStars = 5

    private var normalizedRating: Double {
        return (rating / 10) * Double(totalStars)
    }

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...totalStars, id: \.self) { index in
                if normalizedRating >= Double(index) {
                    Image(systemName: "star.fill")
                } else if normalizedRating > Double(index) - 1 {
                    Image(systemName: "star.leadinghalf.filled")
                } else {
                    Image(systemName: "star")
                }
            }
            .font(.system(size: size))
            .foregroundStyle(.yellow)
        }
    }
}
