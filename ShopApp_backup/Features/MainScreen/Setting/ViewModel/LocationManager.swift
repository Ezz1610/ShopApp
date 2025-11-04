//
//  LocationManager.swift
//  ShopApp
//
//  Created by Soha Elgaly on 26/10/2025.
//

import Foundation
import Foundation
import CoreLocation

@MainActor
final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    @Published var currentCity: String = ""
    @Published var currentCoordinate: CLLocationCoordinate2D?
    @Published var errorMessage: String?
    
    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocationPermission() {
        // Check current authorization
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            errorMessage = "Location access denied. Please enable it in Settings."
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        @unknown default:
            break
        }
    }
    
    
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse ||
            manager.authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        }
    }
    
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.currentCoordinate = location.coordinate
        
       
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            if let city = placemarks?.first?.locality {
                Task { @MainActor in
                    self.currentCity = city
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = error.localizedDescription
    }
}
