//
//  CustomNetworkImage.swift
//  WeatherApp
//
//  Created by mohamed ezz on 12/10/2025.
//
import SwiftUI

struct CustomNetworkImage: View {
    let url: String?
    var width: CGFloat = 100
    var height: CGFloat = 100
    var cornerRadius: CGFloat = 0
    var isCircular: Bool = false

    var body: some View {
        let fullURL: URL? = {
            guard let url = url else { return nil }
            let formatted = url.hasPrefix("http") ? url : "https:" + url
            return URL(string: formatted)
        }()

        AsyncImage(url: fullURL) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: width, height: height)

            case .success(let image):
                imageView(image)

            case .failure(_):
                imageView(Image(systemName: "photo"))

            @unknown default:
                ProgressView()
                    .frame(width: width, height: height)
            }
        }
    }

    @ViewBuilder
    private func imageView(_ image: Image) -> some View {
        if isCircular {
            image
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: width, height: height)
        } else {
            image
                .resizable()
                .scaledToFit()
                .cornerRadius(cornerRadius)
                .frame(width: width, height: height)
        }
    }
}
