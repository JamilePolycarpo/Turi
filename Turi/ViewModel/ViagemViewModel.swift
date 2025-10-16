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

    private let viagensKey = "trips"
   

    init() {
        loadTrips()
    }

    // Adds a new trip with provided name, date and notes
    func addViagem(nome: String, data: Date = Date(), notas: String) {
        let newTrip = Trip(nome: nome, data: data, notas: notas)
        trips.append(newTrip)
    }

   func loadTrips() {
       guard let savedData = UserDefaults.standard.data(forKey: "tripsData") else{return}
       guard let loadedTrips = try? JSONDecoder().decode([Trip].self, from: savedData) else { return }
       trips = loadedTrips
    }

    private func saveTrips() {
        if let data = try? JSONEncoder().encode(trips) {
            UserDefaults.standard.set(data, forKey: "tripsData")
        }
    }
    
    func deleteTrip(at offsets: IndexSet) {
        trips.remove(atOffsets: offsets)
        saveTrips() // garante que o UserDefaults seja atualizado
    }

    func updateTrip(_ trip: Trip, nome: String, data: Date, notas: String?) {
        guard let index = trips.firstIndex(where: { $0.id == trip.id }) else { return }
        
        // Criar um novo Trip com os dados atualizados
        let updatedTrip = Trip(nome: nome, data: data, notas: notas)
        trips[index] = updatedTrip
    }

    func updateTripName(_ trip: Trip, to newName: String) {
        guard let index = trips.firstIndex(where: { $0.id == trip.id }) else { return }
        
        // Criar um novo Trip com o nome atualizado
        let updatedTrip = Trip(nome: newName, data: trip.data, notas: trip.notas)
        trips[index] = updatedTrip
    }
}

