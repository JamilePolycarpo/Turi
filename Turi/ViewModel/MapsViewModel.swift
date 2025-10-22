//
//  MapsViewModel.swift
//  Turi
//
//  Created by Jamile Marian Polycarpo on 03/10/25.
//

import Foundation
import MapKit
import CoreLocation
import Combine
import SwiftUI

@MainActor
class MapsViewModel: ObservableObject {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -23.5505, longitude: -46.6333), // São Paulo
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @Published var searchText = ""
    @Published var searchResults: [Place] = []
    @Published var selectedPlace: Place?
    @Published var isSearching = false
    @Published var route: MKRoute?
    @Published var showingRouteInfo = false
    @Published var userLocation: CLLocation?
    @Published var showingUserLocation = false
    
    private let locationManager = LocationManager()
    private let searchService = MapSearchService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        print("🗺️ MapsViewModel initialized")
        setupLocationUpdates()
    }
    
    // MARK: - Public Methods
    
    func setupLocation() {
        if locationManager.isAuthorized {
            updateMapRegion(to: locationManager.location?.coordinate)
        }
    }
    
    func searchPlaces() {
        guard !searchText.isEmpty else { return }
        
        isSearching = true
        searchResults = []
        
        searchService.searchPlaces(query: searchText, region: region) { [weak self] places in
            Task { @MainActor in
                self?.isSearching = false
                
                // Calculate distances if user location is available
                if let userLocation = self?.locationManager.location {
                    self?.searchResults = places.map { place in
                        let distance = userLocation.distance(from: CLLocation(
                            latitude: place.coordinate.latitude,
                            longitude: place.coordinate.longitude
                        ))
                        return Place(
                            name: place.name,
                            coordinate: place.coordinate,
                            distance: distance
                        )
                    }
                    .sorted { $0.distance < $1.distance }
                    .prefix(5)  // Limitar a apenas 5 lugares mais próximos
                    .map { $0 }
                } else {
                    self?.searchResults = Array(places.prefix(5))
                }
            }
        }
    }
    
    func selectPlace(_ place: Place) {
        selectedPlace = place
        updateMapRegion(to: place.coordinate)
        calculateRoute(to: place)
    }
    
    func clearSearch() {
        searchText = ""
        searchResults = []
        selectedPlace = nil
        showingRouteInfo = false
    }
    
    func hideRouteInfo() {
        showingRouteInfo = false
        route = nil
    }
    
    func clearRoute() {
        route = nil
        showingRouteInfo = false
    }
    
    // MARK: - Private Methods
    
    private func setupLocationUpdates() {
        print("🔧 Setting up location updates")
        locationManager.$location
            .compactMap { $0 }
            .sink { [weak self] location in
                print("📍 Received location update: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                self?.userLocation = location
                self?.showingUserLocation = true
                self?.updateMapRegion(to: location.coordinate)
            }
            .store(in: &cancellables)
    }
    
    private func updateMapRegion(to coordinate: CLLocationCoordinate2D?) {
        guard let coordinate = coordinate else { return }
        
        withAnimation(Animation.easeInOut(duration: 1.0)) {
            region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        }
    }
    
    private func calculateRoute(to destination: Place) {
        guard let userLocation = locationManager.location else { 
            print("❌ Cannot calculate route: no user location")
            return 
        }
        
        searchService.calculateRoute(from: userLocation.coordinate, to: destination.coordinate) { [weak self] route in
            Task { @MainActor in
                if let route = route {
                    self?.route = route
                    self?.showingRouteInfo = true
                    self?.adjustRegionToShowRoute(route: route)
                }
            }
        }
    }
    
    private func adjustRegionToShowRoute(route: MKRoute) {
        let rect = route.polyline.boundingMapRect
        let region = MKCoordinateRegion(rect)
        
        // Adiciona um padding de 20% para melhor visualização
        let paddedRegion = MKCoordinateRegion(
            center: region.center,
            span: MKCoordinateSpan(
                latitudeDelta: region.span.latitudeDelta * 1.4,
                longitudeDelta: region.span.longitudeDelta * 1.4
            )
        )
        
        withAnimation(Animation.easeInOut(duration: 1.0)) {
            self.region = paddedRegion
        }
    }
}
