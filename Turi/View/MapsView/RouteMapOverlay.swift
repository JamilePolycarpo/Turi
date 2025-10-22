//
//  RouteMapOverlay.swift
//  Turi
//
//  Created by Jamile Marian Polycarpo on 03/10/25.
//

import SwiftUI
import MapKit

struct RouteMapOverlay: View {
    let route: MKRoute
    let region: MKCoordinateRegion
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let points = route.polyline.points()
                let pointCount = route.polyline.pointCount
                
                guard pointCount > 0 else { return }
                
                // Converte o primeiro ponto de coordenadas para CGPoint
                if let firstCGPoint = convertCoordinate(points[0].coordinate, in: geometry, region: region) {
                    path.move(to: firstCGPoint)
                    
                    // Desenha linhas para os pontos subsequentes
                    for i in 1..<pointCount {
                        if let cgPoint = convertCoordinate(points[i].coordinate, in: geometry, region: region) {
                            path.addLine(to: cgPoint)
                        }
                    }
                }
            }
            .stroke(Color.blue, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
        }
    }
    
    // Converte coordenadas geográficas para pontos na tela
    private func convertCoordinate(_ coordinate: CLLocationCoordinate2D, in geometry: GeometryProxy, region: MKCoordinateRegion) -> CGPoint? {
        let mapWidth = geometry.size.width
        let mapHeight = geometry.size.height
        
        // Calcula a diferença relativa da coordenada em relação ao centro da região
        let longitudeDelta = region.span.longitudeDelta
        let latitudeDelta = region.span.latitudeDelta
        
        let x = (coordinate.longitude - (region.center.longitude - longitudeDelta / 2)) / longitudeDelta * mapWidth
        let y = ((region.center.latitude + latitudeDelta / 2) - coordinate.latitude) / latitudeDelta * mapHeight
        
        // Verifica se está dentro dos limites visíveis
        guard x >= 0 && x <= mapWidth && y >= 0 && y <= mapHeight else {
            return nil
        }
        
        return CGPoint(x: x, y: y)
    }
}

