//
//  ChatGPTService.swift
//  Turi
//
//  Created on 2025.
//

import Foundation

/// Serviço para integração com a API do ChatGPT (OpenAI)
@MainActor
class ChatGPTService: ObservableObject {
    
    static let shared = ChatGPTService()
    
    private let apiKey: String
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private init() {
        // Busca a API key do Info.plist ou variável de ambiente
        // Para produção, use um arquivo de configuração seguro
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let config = NSDictionary(contentsOfFile: path),
           let key = config["OpenAIAPIKey"] as? String {
            self.apiKey = key
        } else if let key = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] {
            self.apiKey = key
        } else {
            // Fallback: você precisará adicionar sua API key
            self.apiKey = ""
            print("⚠️ OpenAI API Key não encontrada. Configure no Config.plist ou variável de ambiente.")
        }
    }
    
    /// Envia uma mensagem para o ChatGPT e retorna a resposta
    /// - Parameters:
    ///   - message: Mensagem do usuário
    ///   - conversationHistory: Histórico da conversa (opcional)
    /// - Returns: Resposta do ChatGPT ou nil em caso de erro
    func sendMessage(_ message: String, conversationHistory: [ChatMessage] = []) async -> String? {
        guard !apiKey.isEmpty else {
            errorMessage = "API Key do OpenAI não configurada"
            return nil
        }
        
        isLoading = true
        errorMessage = nil
        
        // Prepara o histórico de mensagens
        var messages: [[String: Any]] = [
            [
                "role": "system",
                "content": "Você é um assistente de viagens chamado Turi. Você ajuda usuários com informações sobre viagens, destinos, dicas de viagem, recomendações de lugares para visitar, restaurantes, hotéis e tudo relacionado a turismo. Seja amigável, útil e forneça informações precisas."
            ]
        ]
        
        // Adiciona histórico da conversa
        for chatMessage in conversationHistory {
            let role = chatMessage.sender == .user ? "user" : "assistant"
            messages.append([
                "role": role,
                "content": chatMessage.text
            ])
        }
        
        // Adiciona a mensagem atual
        messages.append([
            "role": "user",
            "content": message
        ])
        
        // Prepara o body da requisição
        let requestBody: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": messages,
            "temperature": 0.7,
            "max_tokens": 500
        ]
        
        guard let url = URL(string: baseURL) else {
            errorMessage = "URL inválida"
            isLoading = false
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                errorMessage = "Resposta inválida do servidor"
                isLoading = false
                return nil
            }
            
            guard httpResponse.statusCode == 200 else {
                if let errorData = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let error = errorData["error"] as? [String: Any],
                   let message = error["message"] as? String {
                    errorMessage = "Erro da API: \(message)"
                } else {
                    errorMessage = "Erro ao comunicar com a API (código: \(httpResponse.statusCode))"
                }
                isLoading = false
                return nil
            }
            
            // Parse da resposta
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let choices = json["choices"] as? [[String: Any]],
                  let firstChoice = choices.first,
                  let message = firstChoice["message"] as? [String: Any],
                  let content = message["content"] as? String else {
                errorMessage = "Formato de resposta inválido"
                isLoading = false
                return nil
            }
            
            isLoading = false
            return content.trimmingCharacters(in: .whitespacesAndNewlines)
            
        } catch {
            errorMessage = "Erro de conexão: \(error.localizedDescription)"
            isLoading = false
            return nil
        }
    }
}


