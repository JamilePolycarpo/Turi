//
//  ViagemViewModel.swift
//  Turi
//
//  Created by Jamile Marian Polycarpo on 05/10/25.
//

import Foundation
import Combine
internal import SwiftUI

final class ViagemViewModel: ObservableObject {
    @Published var trips: [Trip] = [] {
        didSet {
            saveTrips()
        }
    }

    private let viagensKey = "viagens"
    private let notasKey = "viagemNotas"

    init() {
        loadTrips()
    }

    // Adds a new trip with provided name and notes (notes currently unused)
    func addViagem(nome: String, notas: String) {
        let newTrip = Trip(nome: nome, data: Date(), notas: notas)
        trips.append(newTrip)
    }

   func loadTrips() {
        let names = UserDefaults.standard.stringArray(forKey: viagensKey) ?? []
        // For now, we only have titles; create Trip with current date for legacy data.
        self.trips = names.map { Trip(nome: $0, data: Date(), notas: "") }
    }

    private func saveTrips() {
        // Persist only titles for compatibility with existing AddViagemView logic.
        let names = trips.map { $0.nome }
        UserDefaults.standard.set(names, forKey: viagensKey)
    }
    
    func deleteTrip(at offsets: IndexSet) {
        trips.remove(atOffsets: offsets)
        saveTrips() // garante que o UserDefaults seja atualizado
    }
}

