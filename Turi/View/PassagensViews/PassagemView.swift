//
//  PassagemView.swift
//  Turi
//
//  Created by Jamile Marian Polycarpo on 03/10/25.
//

import SwiftUI

struct PassagemView: View {
    @StateObject private var viewModel = FlightSearchViewModel()
    
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
                    
                    // Formulário de busca
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("Ida e volta")
                                .font(.custom("InknutAntiqua-Regular", size: 12))
                                .foregroundColor(Color("FontBackground"))
                            Toggle("", isOn: $viewModel.isRoundTrip)
                                .labelsHidden()
                                .toggleStyle(SwitchToggleStyle(tint: .white))
                        }
                        
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                RoundedTextField(placeholder: "partida", text: $viewModel.origin)
                                RoundedTextField(placeholder: "destino", text: $viewModel.destination)
                            }
                            HStack(spacing: 12) {
                                DateField(title: "data ida", date: $viewModel.departureDate)
                                if viewModel.isRoundTrip {
                                    DateField(title: "data volta", date: $viewModel.returnDate)
                                } else {
                                    RoundedTextField(placeholder: "data volta", text: .constant(""))
                                        .opacity(0.3)
                                        .disabled(true)
                                }
                            }
                            
                            // Número de passageiros
                            HStack {
                                Text("Passageiros:")
                                    .font(.custom("InknutAntiqua-Regular", size: 12))
                                    .foregroundColor(Color("FontBackground"))
                                Stepper("", value: $viewModel.passengers, in: 1...9)
                                    .labelsHidden()
                                Text("\(viewModel.passengers)")
                                    .font(.custom("InknutAntiqua-Regular", size: 12))
                                    .foregroundColor(Color("FontBackground"))
                            }
                        }
                        
                        // Botão de busca
                        Button(action: {
                            viewModel.searchFlights()
                        }) {
                            Text("Buscar Passagens")
                                .font(.custom("InknutAntiqua-Regular", size: 18))
                                .foregroundColor(Color("ColorBackground"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("FontBackground"))
                                .cornerRadius(40)
                        }
                        .disabled(viewModel.isLoading || viewModel.origin.isEmpty || viewModel.destination.isEmpty)
                        .opacity((viewModel.isLoading || viewModel.origin.isEmpty || viewModel.destination.isEmpty) ? 0.5 : 1)
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )
                    
                    // Mensagem de erro
                    if viewModel.showError, let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.horizontal)
                    }
                    
                    // Loading indicator
                    if viewModel.isLoading {
                        ProgressView("Buscando passagens...")
                            .padding()
                    }
                    
                    // Resultados da busca
                    if !viewModel.flights.isEmpty {
                        VStack(spacing: 16) {
                            Text("\(viewModel.flights.count) voo(s) encontrado(s)")
                                .font(.custom("InknutAntiqua-Regular", size: 16))
                                .foregroundColor(Color("FontBackground"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            ForEach(viewModel.flights) { flight in
                                FlightInfoCard(
                                    airlineLogo: flight.airlineLogo,
                                    airlineName: flight.airlineName,
                                    price: flight.formattedPrice,
                                    duration: flight.duration,
                                    stops: flight.stopsDescription,
                                    departureTime: flight.departureTime,
                                    arrivalTime: flight.arrivalTime,
                                    expanded: viewModel.expandedCardId == flight.id,
                                    departureAirport: flight.departureAirport,
                                    arrivalAirport: flight.arrivalAirport
                                )
                                .onTapGesture {
                                    viewModel.toggleCard(flight.id)
                                }
                            }
                        }
                    } else if !viewModel.isLoading && !viewModel.origin.isEmpty && !viewModel.destination.isEmpty {
                        Text("Nenhum voo encontrado. Tente outros critérios de busca.")
                            .font(.custom("InknutAntiqua-Regular", size: 14))
                            .foregroundColor(Color("FontBackground"))
                            .padding()
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
