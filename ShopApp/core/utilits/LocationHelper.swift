//
//  LocationHelper.swift
//  WeatherApp
//
//  Created by mohamed ezz on 12/10/2025.
//

import Foundation
import CoreLocation
import MapKit

// MARK: - City Model
struct City: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    let distance: Double
}

// MARK: - Location Errors
enum LocationError: Error {
    case noLocationFound
    case permissionDenied
    case unknown
}

// MARK: - Location Helper
final class LocationHelper: NSObject, CLLocationManagerDelegate {
    static let shared = LocationHelper()

    private let locationManager = CLLocationManager()
    private var completion: ((Result<CLLocation, Error>) -> Void)?

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    // MARK: - Permissions
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    // MARK: - Get Current Location
    func getCurrentLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        guard CLLocationManager.locationServicesEnabled() else {
            print(" Location services disabled")
            completion(.failure(LocationError.permissionDenied))
            return
        }

        self.completion = completion
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    // MARK: - Get Current City (async)
    func getCurrentCity() async throws -> City {
        let location: CLLocation = try await withCheckedThrowingContinuation { cont in
            getCurrentLocation { result in
                switch result {
                case .success(let loc): cont.resume(returning: loc)
                case .failure(let err): cont.resume(throwing: err)
                }
            }
        }

        let geocoder = CLGeocoder()
        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        guard let placemark = placemarks.first else {
            throw LocationError.noLocationFound
        }

        let name = placemark.locality ?? placemark.subLocality ?? "Unknown City"
        return City(
            name: name,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            distance: 0
        )
    }

    // MARK: - Get Nearby Cities (async)
    func getNearbyCities(limit: Int = 15, radiusMeters: Double = 100_000) async throws -> [City] {
        let currentCity = try await getCurrentCity()
        let currentLocation = CLLocation(latitude: currentCity.latitude, longitude: currentCity.longitude)

        let region = MKCoordinateRegion(
            center: currentLocation.coordinate,
            latitudinalMeters: radiusMeters,
            longitudinalMeters: radiusMeters
        )

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "city"
        request.region = region

        let search = MKLocalSearch(request: request)

        let response: MKLocalSearch.Response = try await withCheckedThrowingContinuation { cont in
            search.start { resp, error in
                if let error = error {
                    cont.resume(throwing: error)
                    return
                }
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
                let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty, !seen.contains(trimmed) else { continue }
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

    // MARK: - CLLocationManagerDelegate
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            print(" Authorized — ready to request location")
        case .denied, .restricted:
            print(" Location permission denied or restricted")
            completion?(.failure(LocationError.permissionDenied))
            completion = nil
        case .notDetermined:
            print(" Waiting for permission...")
        @unknown default:
            completion?(.failure(LocationError.unknown))
            completion = nil
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            completion?(.failure(LocationError.noLocationFound))
            completion = nil
            return
        }
        completion?(.success(location))
        completion = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(" Failed to get location:", error.localizedDescription)
        completion?(.failure(error))
        completion = nil
    }
}
