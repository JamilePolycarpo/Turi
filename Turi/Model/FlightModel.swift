//
//  FlightModel.swift
//  Turi
//
//  Created on 2025.
//

import Foundation

/// Modelo de voo/passagem aérea
struct Flight: Identifiable, Codable {
    let id: String
    let airlineCode: String
    let airlineName: String
    let price: Double
    let currency: String
    let departureTime: String
    let arrivalTime: String
    let departureAirport: String
    let arrivalAirport: String
    let duration: String
    let stops: Int
    let segments: Int
    
    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: NSNumber(value: price)) ?? "R$ \(String(format: "%.2f", price))"
    }
    
    var stopsDescription: String {
        switch stops {
        case 0:
            return "Sem escalas"
        case 1:
            return "1 escala"
        default:
            return "\(stops) escalas"
        }
    }
    
    var airlineLogo: String {
        switch airlineName {
        case "GOL":
            return "gol_logo"
        case "TAP", "TAP Air Portugal":
            return "tap_logo"
        case "American Airlines":
            return "american_logo"
        default:
            return "gol_logo"
        }
    }
}

