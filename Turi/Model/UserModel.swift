//
//  UserModel.swift
//  Turi
//
//  Created on 2025.
//

import Foundation
import FirebaseFirestore

/// Modelo de usuário da aplicação
struct User: Identifiable {
    let id: String
    let name: String
    let email: String
    let profileImageURL: String?
    let createdAt: Date
    let lastLoginAt: Date?
    
    // MARK: - Initializers
    
    init(id: String, name: String, email: String, profileImageURL: String? = nil, createdAt: Date = Date(), lastLoginAt: Date? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.profileImageURL = profileImageURL
        self.createdAt = createdAt
        self.lastLoginAt = lastLoginAt
    }
    
    // MARK: - Firestore Dictionary
    
    /// Converte o User para um dicionário compatível com Firestore
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "name": name,
            "email": email,
            "createdAt": Timestamp(date: createdAt)
        ]
        
        if let profileImageURL = profileImageURL {
            dict["profileImageURL"] = profileImageURL
        }
        
        if let lastLoginAt = lastLoginAt {
            dict["lastLoginAt"] = Timestamp(date: lastLoginAt)
        }
        
        return dict
    }
    
    /// Cria um User a partir de um dicionário do Firestore
    static func fromDictionary(_ dict: [String: Any], id: String) -> User? {
        guard let name = dict["name"] as? String,
              let email = dict["email"] as? String else {
            return nil
        }
        
        let profileImageURL = dict["profileImageURL"] as? String
        
        var createdAt = Date()
        if let timestamp = dict["createdAt"] as? Timestamp {
            createdAt = timestamp.dateValue()
        }
        
        var lastLoginAt: Date? = nil
        if let timestamp = dict["lastLoginAt"] as? Timestamp {
            lastLoginAt = timestamp.dateValue()
        }
        
        return User(
            id: id,
            name: name,
            email: email,
            profileImageURL: profileImageURL,
            createdAt: createdAt,
            lastLoginAt: lastLoginAt
        )
    }
}

