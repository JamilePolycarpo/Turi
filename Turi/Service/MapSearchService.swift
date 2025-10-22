//
//  MapSearchService.swift
//  Turi
//
//  Created by Jamile Marian Polycarpo on 03/10/25.
//

import Foundation
import MapKit
import CoreLocation
import SwiftUI
import Combine

@MainActor
class MapSearchService: ObservableObject {
    
    @Published private(set) var lastQuery: String = ""
    
    func searchPlaces(query: String, region: MKCoordinateRegion, completion: @escaping ([Place]) -> Void) {
        print("🔍 Starting search for: '\(query)'")
        print("🗺️ Region center: \(region.center)")
        
        guard !query.isEmpty else { 
            print("❌ Search text is empty")
            completion([])
            return 
        }
        
        self.lastQuery = query
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Search error: \(error.localizedDescription)")
                    completion([])
                    return
                }
                
                guard let response = response else { 
                    print("❌ No response from search")
                    completion([])
                    return 
                }
                
                print("✅ Found \(response.mapItems.count) results")
                
                let places = response.mapItems.compactMap { mapItem in
                    return Place(
                        name: mapItem.name ?? "Lugar",
                        coordinate: mapItem.placemark.coordinate,
                        distance: 0 // Will be calculated later with user location
                    )
                }
                
                print("📋 Final results: \(places.count) places")
                completion(places)
            }
        }
    }
    
    func calculateRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, completion: @escaping (MKRoute?) -> Void) {
        print("🗺️ Calculating route to: \(destination)")
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Route calculation error: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                guard let route = response?.routes.first else {
                    print("❌ No route found")
                    completion(nil)
                    return
                }
                
                print("✅ Route calculated successfully")
                print("📍 Distance: \(Int(route.distance))m")
                print("⏱️ Expected travel time: \(Int(route.expectedTravelTime / 60)) minutes")
                
                completion(route)
            }
        }
    }
}

