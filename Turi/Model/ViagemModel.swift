//
//  ViagemModel.swift
//  Turi
//
//  Created by Jamile Marian Polycarpo on 05/10/25.
//

import Foundation

struct Trip: Identifiable, Codable, Equatable {
    let id: UUID
    let nome: String
    let data: Date
    let notas: String?
    let createdAt: Date
    
    init(nome: String, data: Date, notas: String? = nil) {
        self.id = UUID()
        self.nome = nome.trimmingCharacters(in: .whitespacesAndNewlines)
        self.data = data
        self.notas = notas?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.createdAt = Date()
    }
    
    // MARK: - Computed Properties
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: data)
    }
    
    var isUpcoming: Bool {
        return data > Date()
    }
    
    var daysUntilTrip: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: data)
        return components.day ?? 0
    }
    
    // MARK: - Validation
    static func isValidTrip(nome: String, data: Date) -> Bool {
        return !nome.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && data > Date()
    }
}

