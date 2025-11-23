//
//  ChatMessageModel.swift
//  Turi
//
//  Created on 2025.
//

import Foundation

/// Modelo de mensagem do chat
struct ChatMessage: Identifiable, Codable {
    enum Sender: String, Codable {
        case user
        case bot
        case typing
    }
    
    let id: UUID
    let text: String
    let sender: Sender
    let timestamp: Date
    
    init(id: UUID = UUID(), text: String, sender: Sender, timestamp: Date = Date()) {
        self.id = id
        self.text = text
        self.sender = sender
        self.timestamp = timestamp
    }
}

