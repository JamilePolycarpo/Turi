//
//  MapsView.swift
//  Turi
//
//  Created by Jamile Marian Polycarpo on 03/10/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapsView: View {
    @StateObject private var viewModel = MapsViewModel()
    @State private var expandedPlaceId: UUID? = nil
    
    var body: some View {
        GeometryReader { geometry in
        ZStack {
                // Background
            Color("ColorBackground")
                    .ignoresSafeArea()
                
            Image("background")
                .resizable()
                .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: geometry.size.height * 0.02) {
                    // Search Bar
                    searchBarView(geometry: geometry)
                    
                    // Map
                    mapView(geometry: geometry)
                    
                    // Results List
                    resultsListView(geometry: geometry)
                }
            }
        }
        .onAppear {
            viewModel.setupLocation()
        }
    }
    
    // MARK: - View Components
    
    private func searchBarView(geometry: GeometryProxy) -> some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color("FontBackground"))
                .font(.system(size: min(geometry.size.width * 0.08, 30)))
            
            TextField("Buscar restaurantes, parques, cafés...", text: $viewModel.searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.system(size: min(geometry.size.width * 0.04, 16)))
                .foregroundColor(Color("FontBackground"))
                .onSubmit {
                    viewModel.searchPlaces()
                }
            
            if !viewModel.searchText.isEmpty {
                Button(action: viewModel.clearSearch) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: min(geometry.size.width * 0.04, 16)))
                }
            }
        }
        .padding(.horizontal, geometry.size.width * 0.04)
        .padding(.vertical, geometry.size.height * 0.015)
        .overlay(
            RoundedRectangle(cornerRadius: geometry.size.width * 0.1)
                .stroke(Color("FontBackground").opacity(0.7), lineWidth: 1)
        )
        .padding(.horizontal, geometry.size.width * 0.05)
        .padding(.top, geometry.size.height * 0.08)
    }
    
    private func mapView(geometry: GeometryProxy) -> some View {
        ZStack {
            Map(coordinateRegion: $viewModel.region, 
                showsUserLocation: true,
                annotationItems: viewModel.searchResults) { place in
                MapAnnotation(coordinate: place.coordinate) {
                    PlacePin(place: place) {
                        viewModel.selectPlace(place)
                    }
                }
            }
            
            // Overlay da rota
            if let route = viewModel.route {
                RouteMapOverlay(route: route, region: viewModel.region)
            }
        }
        .frame(height: geometry.size.height * 0.42)
        .cornerRadius(geometry.size.width * 0.05)
        .shadow(color: .black.opacity(0.15), radius: geometry.size.width * 0.03, x: 0, y: geometry.size.height * 0.007)
        .padding(.horizontal, geometry.size.width * 0.05)
        .padding(.top, geometry.size.height * 0.02)
    }
    
    @ViewBuilder
    private func resultsListView(geometry: GeometryProxy) -> some View {
        if viewModel.isSearching {
            VStack {
                ProgressView()
                    .scaleEffect(min(geometry.size.width * 0.03, 1.2))
                Text("Buscando...")
                    .font(.system(size: min(geometry.size.width * 0.035, 14)))
                    .foregroundColor(.gray)
                    .padding(.top, geometry.size.height * 0.01)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if !viewModel.searchResults.isEmpty {
            ScrollView {
                VStack(spacing: 0) {
                    HStack {
                        Text("5 lugares mais próximos")
                            .font(.system(size: min(geometry.size.width * 0.04, 16), weight: .semibold))
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding(.horizontal, geometry.size.width * 0.05)
                    .padding(.bottom, 8)
                    
                    ForEach(viewModel.searchResults, id: \.id) { place in
                        let isExpanded = expandedPlaceId == place.id
                        let isSelected = viewModel.selectedPlace?.id == place.id
                        
                        PlaceRow(
                            place: place,
                            isSelected: isSelected,
                            expanded: isExpanded,
                            route: isExpanded && isSelected ? viewModel.route : nil
                        ) {
                            withAnimation(.spring()) {
                                // Se já está selecionado, apenas alterna expansão
                                if isSelected {
                                    expandedPlaceId = isExpanded ? nil : place.id
                                } else {
                                    // Se não está selecionado, seleciona e expande
                                    viewModel.selectPlace(place)
                                    expandedPlaceId = place.id
                                }
                            }
                        }
                    }
                }
                .padding(.bottom, geometry.size.height * 0.04)
            }
        } else if viewModel.searchText.isEmpty {
            VStack(spacing: geometry.size.height * 0.02) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: min(geometry.size.width * 0.12, 48)))
                    .foregroundColor(.gray.opacity(0.5))
                
                Text("Digite para buscar lugares")
                    .font(.system(size: min(geometry.size.width * 0.04, 16), weight: .medium))
                    .foregroundColor(.gray)
                
                Text("Ex: restaurantes, parques, cafés...")
                    .font(.system(size: min(geometry.size.width * 0.035, 14)))
                    .foregroundColor(.gray.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, geometry.size.width * 0.1)
        }
    }
}

#Preview {
    MapsView()
    
}

