//
//  FlightSearchViewModel.swift
//  Turi
//
//  Created on 2025.
//

import Foundation
import SwiftUI

/// ViewModel para gerenciar a busca de passagens aéreas
@MainActor
class FlightSearchViewModel: ObservableObject {
    
    @Published var flights: [Flight] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    @Published var origin: String = ""
    @Published var destination: String = ""
    @Published var departureDate: Date = Date()
    @Published var returnDate: Date = Date()
    @Published var isRoundTrip: Bool = false
    @Published var passengers: Int = 1
    
    @Published var expandedCardId: String?
    
    private let amadeusService = AmadeusService.shared
    
    /// Busca passagens aéreas
    func searchFlights() {
        guard !origin.isEmpty, !destination.isEmpty else {
            errorMessage = "Preencha origem e destino"
            showError = true
            return
        }
        
        // Valida datas
        if isRoundTrip && returnDate <= departureDate {
            errorMessage = "A data de volta deve ser posterior à data de ida"
            showError = true
            return
        }
        
        if departureDate < Date() {
            errorMessage = "A data de ida não pode ser no passado"
            showError = true
            return
        }
        
        isLoading = true
        errorMessage = nil
        showError = false
        flights = []
        
        Task {
            let returnDateValue = isRoundTrip ? returnDate : nil
            let results = await amadeusService.searchFlights(
                origin: origin,
                destination: destination,
                departureDate: departureDate,
                returnDate: returnDateValue,
                passengers: passengers
            )
            
            flights = results
            isLoading = false
            
            if flights.isEmpty {
                errorMessage = "Nenhum voo encontrado para os critérios informados"
                showError = true
            } else if let error = amadeusService.errorMessage {
                errorMessage = error
                showError = true
            }
        }
    }
    
    /// Limpa os resultados da busca
    func clearResults() {
        flights = []
        expandedCardId = nil
    }
    
    /// Alterna a expansão de um card
    func toggleCard(_ flightId: String) {
        withAnimation(.spring()) {
            expandedCardId = expandedCardId == flightId ? nil : flightId
        }
    }
}

