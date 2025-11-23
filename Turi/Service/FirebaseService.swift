//
//  FirebaseService.swift
//  Turi
//
//  Created on 2025.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

/// Serviço responsável pela configuração e inicialização do Firebase
class FirebaseService {
    
    static let shared = FirebaseService()
    
    private var isConfigured = false
    
    private init() {}
    
    // MARK: - Configuration
    
    /// Configura o Firebase no app
    /// - Returns: true se configurado com sucesso, false caso contrário
    func configure() -> Bool {
        guard !isConfigured else {
            print("✅ Firebase já está configurado")
            return true
        }
        
        // Verifica se o GoogleService-Info.plist existe
        guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path) else {
            print("⚠️ GoogleService-Info.plist não encontrado. Configure o Firebase primeiro.")
            return false
        }
        
        // Configura o Firebase
        FirebaseApp.configure()
        isConfigured = true
        print("✅ Firebase configurado com sucesso")
        
        return true
    }
    
    /// Verifica se o Firebase está configurado
    var isFirebaseConfigured: Bool {
        return isConfigured && FirebaseApp.app() != nil
    }
}

