//
//  FligthInfoCard.swift
//  Turi
//
//  Created by Leonardo Macedo on 19/10/25.
//

internal import SwiftUI

struct FlightInfoCard: View {
    let airlineLogo: String
    let airlineName: String
    let price: String
    let duration: String
    let stops: String
    let departureTime: String
    let arrivalTime: String
    let expanded: Bool
    let departureAirport: String?
    let arrivalAirport: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center) {
                // Logo da companhia
                Image(airlineLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(price)
                        .font(.title3).bold()
                        .foregroundColor(.black)
                    
                    HStack(spacing: 4) {
                        Text("\(departureTime) → \(arrivalTime)")
                            .font(.subheadline)
                        Text("(\(duration))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Text(stops)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: expanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.gray)
                    .padding(.trailing, 8)
            }
            
            if expanded, let departureAirport = departureAirport, let arrivalAirport = arrivalAirport {
                Divider()
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 8, height: 8)
                        Text(departureAirport)
                            .font(.footnote)
                    }
                    HStack {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 8, height: 8)
                        Text(arrivalAirport)
                            .font(.footnote)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    VStack(spacing: 16) {
        FlightInfoCard(
            airlineLogo: "gol_logo",
            airlineName: "GOL",
            price: "R$ 1.520,00",
            duration: "2h 30m",
            stops: "2 escalas",
            departureTime: "00:00",
            arrivalTime: "02:30",
            expanded: false,
            departureAirport: nil,
            arrivalAirport: nil
        )
        
        FlightInfoCard(
            airlineLogo: "american_logo",
            airlineName: "American Airlines",
            price: "R$ 2.020,00",
            duration: "2h 30m",
            stops: "Sem escalas",
            departureTime: "00:00",
            arrivalTime: "02:30",
            expanded: true,
            departureAirport: "Aeroporto Internacional de São Paulo/Guarulhos — Governador André Franco Montoro (GRU)",
            arrivalAirport: "Aeroporto Internacional de Salvador Luís Eduardo Magalhães (SSA)"
        )
    }
    .padding()
}
