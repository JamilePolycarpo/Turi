//
//  PlaceModel.swift
//  Turi
//
//  Created by Jamile Marian Polycarpo on 03/10/25.
//

import Foundation
import MapKit

struct Place: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let distance: CLLocationDistance
}
