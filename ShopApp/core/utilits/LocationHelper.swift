//
//  LocationHelper.swift
//  WeatherApp
//
//  Created by mohamed ezz on 12/10/2025.
//

import Foundation
import CoreLocation
import MapKit


struct City: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    let distance: Double
}

final class LocationHelper {
    static let shared = LocationHelper()
    private init() {}

    // موقع القاهرة (ثابت — بدون GPS)
    private let cairoLocation = CLLocation(latitude: 30.0444, longitude: 31.2357)

    /// يرجّع مدينة القاهرة كـ City Model ثابت
    func getCurrentCity() -> City {
        return City(
            name: "Cairo",
            latitude: 30.0444,
            longitude: 31.2357,
            distance: 0
        )
    }

    /// يجيب أقرب مدن حوالين القاهرة دائمًا (باستخدام MapKit)
    func getNearbyCities(limit: Int = 15, radiusMeters: Double = 100_000) async throws -> [City] {
        let currentLocation = cairoLocation
        let center = currentLocation.coordinate

        let region = MKCoordinateRegion(
            center: center,
            latitudinalMeters: radiusMeters,
            longitudinalMeters: radiusMeters
        )

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "city"
        request.region = region

        let search = MKLocalSearch(request: request)

        let response: MKLocalSearch.Response = try await withCheckedThrowingContinuation { cont in
            search.start { resp, error in
                if let error = error { cont.resume(throwing: error); return }
                guard let resp = resp else {
                    cont.resume(throwing: LocationError.noLocationFound)
                    return
                }
                cont.resume(returning: resp)
            }
        }


        var seen = Set<String>()
        var cities: [City] = []

        for item in response.mapItems {
            let placemark = item.placemark
            if let name = placemark.locality ?? placemark.subLocality ?? placemark.name {
                let trimmed = name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) // ✅ تم اصلاحها
                guard !trimmed.isEmpty else { continue }
                if seen.contains(trimmed) { continue }
                seen.insert(trimmed)

                let coord = placemark.coordinate
                let dist = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
                    .distance(from: currentLocation)

                let city = City(name: trimmed, latitude: coord.latitude, longitude: coord.longitude, distance: dist)
                cities.append(city)
            }
            if cities.count >= limit { break }
        }

        cities.sort { $0.distance < $1.distance }
        return Array(cities.prefix(limit))
    }
}

enum LocationError: Error {
    case noLocationFound
}
