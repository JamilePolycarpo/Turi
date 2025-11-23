//
//  AmadeusService.swift
//  Turi
//
//  Created on 2025.
//

import Foundation

/// Serviço para integração com a API da Amadeus
/// Documentação: https://developers.amadeus.com/
@MainActor
class AmadeusService: ObservableObject {
    
    static let shared = AmadeusService()
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // Credenciais da Amadeus
    private var clientId: String
    private var clientSecret: String
    private let baseURL = "https://api.amadeus.com"
    
    // Token de acesso (OAuth)
    private var accessToken: String?
    private var tokenExpiryDate: Date?
    
    private init() {
        // Busca credenciais do Config.plist ou variáveis de ambiente
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let config = NSDictionary(contentsOfFile: path) {
            self.clientId = config["AmadeusClientID"] as? String ?? ""
            self.clientSecret = config["AmadeusClientSecret"] as? String ?? ""
        } else {
            // Fallback para variáveis de ambiente
            self.clientId = ProcessInfo.processInfo.environment["AMADEUS_CLIENT_ID"] ?? ""
            self.clientSecret = ProcessInfo.processInfo.environment["AMADEUS_CLIENT_SECRET"] ?? ""
        }
    }
    
    // MARK: - Authentication
    
    /// Obtém um token de acesso OAuth da Amadeus
    private func getAccessToken() async -> String? {
        // Verifica se já temos um token válido
        if let token = accessToken,
           let expiry = tokenExpiryDate,
           expiry > Date() {
            return token
        }
        
        guard !clientId.isEmpty, !clientSecret.isEmpty else {
            errorMessage = "Credenciais da Amadeus não configuradas"
            return nil
        }
        
        guard let url = URL(string: "\(baseURL)/v1/security/oauth2/token") else {
            errorMessage = "URL inválida"
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodyString = "grant_type=client_credentials&client_id=\(clientId)&client_secret=\(clientSecret)"
        request.httpBody = bodyString.data(using: .utf8)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                errorMessage = "Erro ao autenticar na Amadeus"
                return nil
            }
            
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let token = json["access_token"] as? String,
                  let expiresIn = json["expires_in"] as? Int else {
                errorMessage = "Formato de resposta de autenticação inválido"
                return nil
            }
            
            // Salva o token e calcula a data de expiração
            accessToken = token
            tokenExpiryDate = Date().addingTimeInterval(TimeInterval(expiresIn - 60)) // -60 para margem de segurança
            
            return token
            
        } catch {
            errorMessage = "Erro de conexão: \(error.localizedDescription)"
            return nil
        }
    }
    
    // MARK: - Flight Search
    
    /// Busca passagens aéreas usando a API da Amadeus
    /// - Parameters:
    ///   - origin: Código IATA do aeroporto de origem (ex: "GRU")
    ///   - destination: Código IATA do aeroporto de destino (ex: "SSA")
    ///   - departureDate: Data de ida (formato: YYYY-MM-DD)
    ///   - returnDate: Data de volta (opcional, formato: YYYY-MM-DD)
    ///   - passengers: Número de passageiros adultos
    /// - Returns: Lista de voos encontrados
    func searchFlights(
        origin: String,
        destination: String,
        departureDate: Date,
        returnDate: Date? = nil,
        passengers: Int = 1
    ) async -> [Flight] {
        
        isLoading = true
        errorMessage = nil
        
        // Se não houver credenciais, retorna dados mockados
        guard !clientId.isEmpty, !clientSecret.isEmpty else {
            print("⚠️ Credenciais da Amadeus não configuradas. Retornando dados de exemplo.")
            isLoading = false
            return generateMockFlights(origin: origin, destination: destination, departureDate: departureDate, returnDate: returnDate)
        }
        
        // Obtém token de acesso
        guard let token = await getAccessToken() else {
            isLoading = false
            // Retorna dados mockados em caso de erro de autenticação
            return generateMockFlights(origin: origin, destination: destination, departureDate: departureDate, returnDate: returnDate)
        }
        
        // Formata datas
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let depDateString = dateFormatter.string(from: departureDate)
        let retDateString = returnDate != nil ? dateFormatter.string(from: returnDate!) : nil
        
        // Endpoint da Amadeus para busca de voos
        let endpoint = "/v2/shopping/flight-offers"
        guard let url = URL(string: baseURL + endpoint) else {
            errorMessage = "URL inválida"
            isLoading = false
            return []
        }
        
        // Parâmetros da query
        var queryItems = [
            URLQueryItem(name: "originLocationCode", value: origin.uppercased()),
            URLQueryItem(name: "destinationLocationCode", value: destination.uppercased()),
            URLQueryItem(name: "departureDate", value: depDateString),
            URLQueryItem(name: "adults", value: "\(passengers)"),
            URLQueryItem(name: "max", value: "10") // Limita a 10 resultados
        ]
        
        if let retDate = retDateString {
            queryItems.append(URLQueryItem(name: "returnDate", value: retDate))
        }
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = queryItems
        
        guard let finalURL = urlComponents?.url else {
            errorMessage = "Erro ao construir URL"
            isLoading = false
            return []
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                errorMessage = "Resposta inválida do servidor"
                isLoading = false
                return generateMockFlights(origin: origin, destination: destination, departureDate: departureDate, returnDate: returnDate)
            }
            
            guard httpResponse.statusCode == 200 else {
                // Tenta parsear erro da Amadeus
                if let errorData = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let errors = errorData["errors"] as? [[String: Any]],
                   let firstError = errors.first,
                   let detail = firstError["detail"] as? String {
                    errorMessage = "Erro da Amadeus: \(detail)"
                } else {
                    errorMessage = "Erro ao buscar voos (código: \(httpResponse.statusCode))"
                }
                isLoading = false
                // Retorna dados mockados em caso de erro
                return generateMockFlights(origin: origin, destination: destination, departureDate: departureDate, returnDate: returnDate)
            }
            
            // Parse da resposta da Amadeus
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let dataArray = json["data"] as? [[String: Any]] else {
                errorMessage = "Formato de resposta inválido"
                isLoading = false
                return generateMockFlights(origin: origin, destination: destination, departureDate: departureDate, returnDate: returnDate)
            }
            
            let flights = parseAmadeusResponse(dataArray)
            isLoading = false
            return flights.isEmpty ? generateMockFlights(origin: origin, destination: destination, departureDate: departureDate, returnDate: returnDate) : flights
            
        } catch {
            errorMessage = "Erro de conexão: \(error.localizedDescription)"
            isLoading = false
            // Retorna dados mockados em caso de erro
            return generateMockFlights(origin: origin, destination: destination, departureDate: departureDate, returnDate: returnDate)
        }
    }
    
    // MARK: - Response Parsing
    
    /// Parse da resposta da API Amadeus
    private func parseAmadeusResponse(_ data: [[String: Any]]) -> [Flight] {
        var flights: [Flight] = []
        
        for item in data {
            guard let price = item["price"] as? [String: Any],
                  let total = price["total"] as? String,
                  let priceValue = Double(total),
                  let itineraries = item["itineraries"] as? [[String: Any]],
                  let firstItinerary = itineraries.first,
                  let segments = firstItinerary["segments"] as? [[String: Any]],
                  segments.count > 0 else {
                continue
            }
            
            let firstSegment = segments.first!
            let lastSegment = segments.last!
            
            guard let depTime = firstSegment["departure"] as? [String: Any],
                  let depAt = depTime["at"] as? String,
                  let depIata = depTime["iataCode"] as? String,
                  let arrTime = lastSegment["arrival"] as? [String: Any],
                  let arrAt = arrTime["at"] as? String,
                  let arrIata = arrTime["iataCode"] as? String,
                  let carrier = firstSegment["carrierCode"] as? String else {
                continue
            }
            
            // Calcula duração
            let duration = calculateDuration(departure: depAt, arrival: arrAt)
            let stops = segments.count - 1
            
            // Busca nome do aeroporto (se disponível)
            let depAirportName = getAirportName(code: depIata)
            let arrAirportName = getAirportName(code: arrIata)
            
            let flight = Flight(
                id: item["id"] as? String ?? UUID().uuidString,
                airlineCode: carrier,
                airlineName: getAirlineName(code: carrier),
                price: priceValue,
                currency: price["currency"] as? String ?? "BRL",
                departureTime: formatTime(depAt),
                arrivalTime: formatTime(arrAt),
                departureAirport: depAirportName,
                arrivalAirport: arrAirportName,
                duration: duration,
                stops: stops,
                segments: segments.count
            )
            
            flights.append(flight)
        }
        
        return flights.sorted { $0.price < $1.price }
    }
    
    // MARK: - Helpers
    
    private func calculateDuration(departure: String, arrival: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let depDate = formatter.date(from: departure),
              let arrDate = formatter.date(from: arrival) else {
            return "N/A"
        }
        
        let interval = arrDate.timeIntervalSince(depDate)
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        
        return "\(hours)h \(minutes)m"
    }
    
    private func formatTime(_ isoString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = formatter.date(from: isoString) else {
            return "N/A"
        }
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        return timeFormatter.string(from: date)
    }
    
    private func getAirlineName(code: String) -> String {
        let airlines: [String: String] = [
            "G3": "GOL",
            "TP": "TAP Air Portugal",
            "AA": "American Airlines",
            "LA": "LATAM",
            "AD": "Azul",
            "JJ": "LATAM Brasil",
            "IB": "Iberia",
            "BA": "British Airways",
            "AF": "Air France",
            "KL": "KLM",
            "LH": "Lufthansa"
        ]
        return airlines[code] ?? code
    }
    
    private func getAirportName(code: String) -> String {
        let airports: [String: String] = [
            "GRU": "Aeroporto Internacional de São Paulo/Guarulhos (GRU)",
            "SSA": "Aeroporto Internacional de Salvador (SSA)",
            "GIG": "Aeroporto Internacional do Rio de Janeiro/Galeão (GIG)",
            "SDU": "Aeroporto Santos Dumont (SDU)",
            "CGH": "Aeroporto de Congonhas (CGH)",
            "BSB": "Aeroporto Internacional de Brasília (BSB)",
            "FOR": "Aeroporto Internacional de Fortaleza (FOR)",
            "REC": "Aeroporto Internacional do Recife (REC)",
            "POA": "Aeroporto Internacional Salgado Filho (POA)",
            "CWB": "Aeroporto Internacional Afonso Pena (CWB)"
        ]
        return airports[code] ?? "Aeroporto \(code)"
    }
    
    // MARK: - Mock Data
    
    /// Gera voos mockados para desenvolvimento/teste
    private func generateMockFlights(origin: String, destination: String, departureDate: Date, returnDate: Date?) -> [Flight] {
        let airlines = [
            ("GOL", "gol_logo", "G3"),
            ("TAP", "tap_logo", "TP"),
            ("American Airlines", "american_logo", "AA"),
            ("LATAM", "gol_logo", "LA"),
            ("Azul", "gol_logo", "AD")
        ]
        
        var flights: [Flight] = []
        
        for (index, airline) in airlines.enumerated() {
            let basePrice = Double.random(in: 1200...2500)
            let stops = index % 3
            let duration = "\(2 + index)h \(30 + index * 10)m"
            
            let flight = Flight(
                id: UUID().uuidString,
                airlineCode: airline.2,
                airlineName: airline.0,
                price: basePrice,
                currency: "BRL",
                departureTime: String(format: "%02d:00", 6 + index * 2),
                arrivalTime: String(format: "%02d:30", 8 + index * 2),
                departureAirport: getAirportName(code: origin.uppercased()),
                arrivalAirport: getAirportName(code: destination.uppercased()),
                duration: duration,
                stops: stops,
                segments: stops + 1
            )
            
            flights.append(flight)
        }
        
        return flights
    }
}

