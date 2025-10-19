//
//  LocationHelper.swift
//  WeatherApp
//
//  Created by mohamed ezz on 12/10/2025.
//
import Foundation
import CoreLocation

final class LocationHelper: NSObject, CLLocationManagerDelegate {
    static let shared = LocationHelper()

    private let locationManager = CLLocationManager()
    private var completion: ((CLLocation?) -> Void)?

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func getCurrentLocation(completion: @escaping (CLLocation?) -> Void) {
        guard CLLocationManager.locationServicesEnabled() else {
            print("location services are disabled")
            completion(nil)
            return
        }

        self.completion = completion
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus

        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("authorized — requesting location...")
            locationManager.requestLocation()

        case .denied, .restricted:
            print("location permission denied or restricted")

        case .notDetermined:
            print("waiting for permission...")

        @unknown default:
            print("unknown authorization status")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            print("no location found")
            completion?(nil)
            completion = nil
            return
        }

        print("location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        completion?(location)
        completion = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("failed to get location:", error.localizedDescription)
        completion?(nil)
        completion = nil
    }
}

