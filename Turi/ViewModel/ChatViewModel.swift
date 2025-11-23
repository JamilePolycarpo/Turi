//
//  ChatViewModel.swift
//  Turi
//
//  Created on 2025.
//

import Foundation
import SwiftUI

/// ViewModel para gerenciar o estado do chat
@MainActor
class ChatViewModel: ObservableObject {
    
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    private let chatGPTService = ChatGPTService.shared
    
    init() {
        // Mensagem de boas-vindas
        let welcomeMessage = ChatMessage(
            text: "Olá! Sou o Turi, seu assistente de viagens. Como posso ajudar você hoje?",
            sender: .bot
        )
        messages.append(welcomeMessage)
    }
    
    /// Envia uma mensagem para o ChatGPT
    func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        let userMessage = ChatMessage(text: inputText, sender: .user)
        messages.append(userMessage)
        
        let messageText = inputText
        inputText = ""
        
        // Adiciona indicador de digitação
        let typingMessage = ChatMessage(text: "", sender: .typing)
        messages.append(typingMessage)
        
        isLoading = true
        
        Task {
            // Remove o indicador de digitação
            messages.removeAll { $0.sender == .typing }
            
            // Busca histórico da conversa (últimas 10 mensagens)
            let history = Array(messages.suffix(10))
            
            // Envia para o ChatGPT
            if let response = await chatGPTService.sendMessage(messageText, conversationHistory: history) {
                let botMessage = ChatMessage(text: response, sender: .bot)
                messages.append(botMessage)
                isLoading = false
            } else {
                // Erro ao obter resposta
                if let error = chatGPTService.errorMessage {
                    errorMessage = error
                    showError = true
                } else {
                    errorMessage = "Erro ao obter resposta do assistente"
                    showError = true
                }
                
                // Adiciona mensagem de erro
                let errorBotMessage = ChatMessage(
                    text: "Desculpe, ocorreu um erro ao processar sua mensagem. Por favor, tente novamente.",
                    sender: .bot
                )
                messages.append(errorBotMessage)
                isLoading = false
            }
        }
    }
    
    /// Limpa o histórico de mensagens
    func clearChat() {
        messages.removeAll()
        let welcomeMessage = ChatMessage(
            text: "Olá! Sou o Turi, seu assistente de viagens. Como posso ajudar você hoje?",
            sender: .bot
        )
        messages.append(welcomeMessage)
    }
}

