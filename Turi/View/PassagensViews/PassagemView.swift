//
//  PassagemView.swift
//  Turi
//
//  Created by Jamile Marian Polycarpo on 03/10/25.
//

import SwiftUI

struct PassagemView: View {
    @State private var isRoundTrip: Bool = false
    @State private var expandedCard: Int? = nil
    @State private var partida: String = ""
    @State private var destino: String = ""
    @State private var dataIda: Date = Date()
    @State private var dataVolta: Date = Date()
    
    var body: some View {
        ZStack {
            Color("ColorBackground")
                .ignoresSafeArea(edges: .all)
            
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(edges: .all)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("Ida e volta")
                                .font(.custom("InknutAntiqua-Regular", size: 12))
                                .foregroundColor(Color("FontBackground"))
                            Toggle("", isOn: $isRoundTrip)
                                .labelsHidden()
                                .toggleStyle(SwitchToggleStyle(tint: .white))
                        }
                        
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                RoundedTextField(placeholder: "partida", text: $partida)
                                RoundedTextField(placeholder: "destino", text: $destino)
                            }
                            HStack(spacing: 12) {
                                DateField(title: "data ida", date: $dataIda)
                                if isRoundTrip {
                                    DateField(title: "data volta", date: $dataVolta)
                                } else {
                                    RoundedTextField(placeholder: "data volta", text: .constant(""))
                                        .opacity(0.3)
                                        .disabled(true)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )
                    
                    VStack(spacing: 16) {
                        FlightInfoCard(
                            airlineLogo: "gol_logo",
                            airlineName: "GOL",
                            price: "R$ 1.520,00",
                            duration: "2h 30m",
                            stops: "2 escalas",
                            departureTime: "00:00",
                            arrivalTime: "02:30",
                            expanded: expandedCard == 1,
                            departureAirport: "Aeroporto Internacional de São Paulo/Guarulhos (GRU)",
                            arrivalAirport: "Aeroporto Internacional de Salvador (SSA)"
                        )
                        .onTapGesture {
                            withAnimation(.spring()) {
                                expandedCard = expandedCard == 1 ? nil : 1
                            }
                        }
                        
                        FlightInfoCard(
                            airlineLogo: "tap_logo",
                            airlineName: "TAP",
                            price: "R$ 1.740,00",
                            duration: "2h 30m",
                            stops: "1 escala",
                            departureTime: "00:00",
                            arrivalTime: "02:30",
                            expanded: expandedCard == 2,
                            departureAirport: "Aeroporto Internacional de São Paulo/Guarulhos (GRU)",
                            arrivalAirport: "Aeroporto Internacional de Salvador (SSA)"
                        )
                        .onTapGesture {
                            withAnimation(.spring()) {
                                expandedCard = expandedCard == 2 ? nil : 2
                            }
                        }
                        
                        FlightInfoCard(
                            airlineLogo: "american_logo",
                            airlineName: "American Airlines",
                            price: "R$ 2.020,00",
                            duration: "2h 30m",
                            stops: "Sem escalas",
                            departureTime: "00:00",
                            arrivalTime: "02:30",
                            expanded: expandedCard == 3,
                            departureAirport: "Aeroporto Internacional de São Paulo/Guarulhos — Governador André Franco Montoro (GRU)",
                            arrivalAirport: "Aeroporto Internacional de Salvador Luís Eduardo Magalhães (SSA)"
                        )
                        .onTapGesture {
                            withAnimation(.spring()) {
                                expandedCard = expandedCard == 3 ? nil : 3
                            }
                        }
                    }
                }
                .padding(.top, 60)
                .padding()
            }
        }
    }
}

#Preview {
    PassagemView()
}
