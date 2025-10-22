//
//  RouteOverlay.swift
//  Turi
//
//  Created by Jamile Marian Polycarpo on 03/10/25.
//

import SwiftUI
import MapKit

struct RouteOverlay: View {
    let route: MKRoute
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                // Convert route polyline to path
                let points = route.polyline.points()
                let pointCount = route.polyline.pointCount
                
                if pointCount > 0 {
                    let firstPoint = points[0]
                    path.move(to: CGPoint(x: firstPoint.x, y: firstPoint.y))
                    
                    for i in 1..<pointCount {
                        let point = points[i]
                        path.addLine(to: CGPoint(x: point.x, y: point.y))
                    }
                }
            }
            .stroke(Color.blue, lineWidth: 4)
            .opacity(0.8)
        }
    }
}

#Preview {
    RouteOverlay(route: MKRoute())
        .frame(width: 300, height: 200)
}

