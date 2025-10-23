//
//  PlaceViews.swift
//  Turi
//
//  Created by Jamile Marian Polycarpo on 03/10/25.
//

import SwiftUI
import MapKit

struct PlacePin: View {
    let place: Place
    let onTap: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            Button(action: onTap) {
                VStack(spacing: geometry.size.width * 0.02) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                        .font(.system(size: min(geometry.size.width * 0.06, 24)))
                        .background(
                            Circle()
                                .fill(Color.white)
                                .frame(width: min(geometry.size.width * 0.075, 30), height: min(geometry.size.width * 0.075, 30))
                        )
                    
                    Text(place.name)
                        .font(.system(size: min(geometry.size.width * 0.03, 12), weight: .medium))
                        .foregroundColor(.primary)
                        .padding(.horizontal, geometry.size.width * 0.02)
                        .padding(.vertical, geometry.size.height * 0.01)
                        .background(
                            RoundedRectangle(cornerRadius: geometry.size.width * 0.02)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.1), radius: geometry.size.width * 0.005, x: 0, y: geometry.size.height * 0.002)
                        )
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .frame(width: 120, height: 80)
    }
}

struct PlaceRow: View {
    let place: Place
    let isSelected: Bool
    let expanded: Bool
    let route: MKRoute?
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 16) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(isSelected ? Color("FontBackground") : Color("ColorBackground"))
                        .font(.system(size: 20))
                        .frame(width: 32, height: 32)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(place.name)
                            .font(.custom("InknutAntiqua-Bold", size: 16))
                            .foregroundColor(Color("ColorBackground"))
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(Color("ColorBackground"))
                        .font(.system(size: 20, weight: .semibold))
                }
                
                // Conteúdo expandido - Informações da Rota
                if expanded, let route = route {
                    Divider()
                        .background(Color("ColorBackground").opacity(0.3))
                        .padding(.vertical, 4)
                    
                    HStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 4) {
                                Image(systemName: "car.fill")
                                    .foregroundColor(Color("ColorBackground"))
                                    .font(.system(size: 12))
                                Text("Distância")
                                    .font(.custom("InknutAntiqua-Bold", size: 12))
                                    .foregroundColor(Color("ColorBackground").opacity(0.7))
                            }
                            Text(formatDistance(route.distance))
                                .font(.custom("InknutAntiqua-Bold", size: 16))
                                .foregroundColor(Color("ColorBackground"))
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            HStack(spacing: 4) {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(Color("ColorBackground"))
                                    .font(.system(size: 12))
                                Text("Tempo")
                                    .font(.custom("InknutAntiqua-Bold", size: 12))
                                    .foregroundColor(Color("ColorBackground").opacity(0.7))
                            }
                            Text("\(Int(route.expectedTravelTime / 60)) min")
                                .font(.custom("InknutAntiqua-Bold", size: 16))
                                .foregroundColor(Color("ColorBackground"))
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color("FontBackground"))
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
}


struct RouteInfoView: View {
    let route: MKRoute
    let destinationName: String
    let onClose: () -> Void
    let onClearRoute: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: geometry.size.height * 0.02) {
                HStack {
                    Image(systemName: "car.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: min(geometry.size.width * 0.04, 16)))
                    
                    Text("Rota para \(destinationName)")
                        .font(.system(size: min(geometry.size.width * 0.04, 16), weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Button(action: onClearRoute) {
                        Image(systemName: "trash.circle.fill")
                            .foregroundColor(.red)
                            .font(.system(size: min(geometry.size.width * 0.04, 16)))
                    }
                    
                    Button(action: onClose) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: min(geometry.size.width * 0.04, 16)))
                    }
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: geometry.size.height * 0.01) {
                        Text("Distância")
                            .font(.system(size: min(geometry.size.width * 0.03, 12)))
                            .foregroundColor(Color("ColorBackground"))
                        Text("\(Int(route.distance / 1000)) km")
                            .font(.system(size: min(geometry.size.width * 0.035, 14), weight: .medium))
                            .foregroundColor(Color("ColorBackground"))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: geometry.size.height * 0.01) {
                        Text("Tempo")
                            .font(.system(size: min(geometry.size.width * 0.03, 12)))
                            .foregroundColor(.gray)
                        Text("\(Int(route.expectedTravelTime / 60)) min")
                            .font(.system(size: min(geometry.size.width * 0.035, 14), weight: .medium))
                            .foregroundColor(.primary)
                    }
                }
            }
            .padding(.horizontal, geometry.size.width * 0.05)
            .padding(.vertical, geometry.size.height * 0.04)
            .background(
                RoundedRectangle(cornerRadius: geometry.size.width * 0.03)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: geometry.size.width * 0.01, x: 0, y: geometry.size.height * 0.005)
            )
        }
        .frame(height: 100)
    }
}

// MARK: - Helper Functions
private func formatDistance(_ distance: Double) -> String {
    if distance < 1000 {
        return "\(Int(distance)) m"
    } else {
        let km = distance / 1000
        return String(format: "%.1f km", km)
    }
}

#if DEBUG
import CoreLocation

private extension Place {
    static var mock: Place {
        // Adjust to your real Place initializer/properties if needed
        // Assuming Place has at least: name: String, distance: Double, coordinate optional
        return Place(name: "Central Park", coordinate: CLLocationCoordinate2D(latitude: 40.785091, longitude: -73.968285), distance: 350)
    }
}

@available(iOS 17.0, *)
#Preview("PlaceRow - Default") {
    ZStack {
        Color("ColorBackground").ignoresSafeArea()
        VStack(spacing: 16) {
            PlaceRow(place: .mock, isSelected: false, expanded: false, route: nil, onTap: {})
            PlaceRow(place: .mock, isSelected: true, expanded: true, route: nil, onTap: {})
        }
        .padding()
    }
}

@available(iOS 17.0, *)
#Preview("PlacePin") {
    ZStack {
        Color("ColorBackground").ignoresSafeArea()
        PlacePin(place: .mock, onTap: {})
    }
    .frame(width: 160, height: 120)
}
#endif

