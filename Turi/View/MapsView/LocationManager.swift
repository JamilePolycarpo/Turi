//
//  LocationManager.swift
//  Turi
//
//  Created by Jamile Marian Polycarpo on 03/10/25.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var location: CLLocation?
    @Published var isAuthorized = false
    
    override init() {
        super.init()
        print("🏗️ LocationManager init started")
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Verifica o status atual de autorização
        checkAuthorizationStatus()
        print("🏗️ LocationManager init completed")
    }
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    private func checkAuthorizationStatus() {
        let status = manager.authorizationStatus
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            isAuthorized = true
            manager.startUpdatingLocation()
            print("✅ Location already authorized, starting updates")
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            print("❓ Requesting location permission")
        case .denied, .restricted:
            isAuthorized = false
            print("❌ Location access denied or restricted")
        @unknown default:
            print("❓ Unknown location authorization status")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
            print("📍 Location updated: \(newLocation.coordinate)")
            location = newLocation
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Location error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("📍 Location authorization changed: \(status.rawValue)")
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            isAuthorized = true
            manager.startUpdatingLocation()
            print("✅ Location authorized, starting updates")
        case .denied, .restricted:
            isAuthorized = false
            print("❌ Location denied or restricted")
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            print("❓ Location permission not determined, requesting")
        @unknown default:
            print("❓ Unknown location authorization status")
            break
        }
    }
}
