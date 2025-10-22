//
//  UserLocationPin.swift
//  Turi
//
//  Created by Jamile Marian Polycarpo on 03/10/25.
//

import SwiftUI
import MapKit

struct UserLocationPin: View {
    let coordinate: CLLocationCoordinate2D
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Pulsing circle
                Circle()
                    .fill(Color.blue.opacity(0.3))
                    .frame(width: 40, height: 40)
                    .scaleEffect(1.5)
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                        value: UUID()
                    )
                
                // Inner dot
                Circle()
                    .fill(Color.blue)
                    .frame(width: 16, height: 16)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                    )
            }
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}

#Preview {
    UserLocationPin(coordinate: CLLocationCoordinate2D(latitude: -23.5505, longitude: -46.6333))
        .frame(width: 100, height: 100)
}
