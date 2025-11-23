//
//  AuthService.swift
//  Turi
//
//  Created on 2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
typealias FirestoreTimestamp = FirebaseFirestore.Timestamp

/// Serviço responsável por todas as operações de autenticação
@MainActor
class AuthService: ObservableObject {
    
    static let shared = AuthService()
    
    @Published var currentUser: User?
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    
    private init() {
        // Observa mudanças no estado de autenticação
        Auth.auth().addStateDidChangeListener { [weak self] _, firebaseUser in
            Task { @MainActor in
                if let firebaseUser = firebaseUser {
                    await self?.loadUserData(userId: firebaseUser.uid)
                    self?.isAuthenticated = true
                } else {
                    self?.currentUser = nil
                    self?.isAuthenticated = false
                }
            }
        }
    }
    
    // MARK: - Email/Password Authentication
    
    /// Realiza login com email e senha
    /// - Parameters:
    ///   - email: Email do usuário
    ///   - password: Senha do usuário
    /// - Returns: true se login bem-sucedido, false caso contrário
    func signIn(email: String, password: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            await loadUserData(userId: result.user.uid)
            await updateLastLogin(userId: result.user.uid)
            isAuthenticated = true
            isLoading = false
            return true
        } catch {
            errorMessage = handleAuthError(error)
            isLoading = false
            return false
        }
    }
    
    /// Cria uma nova conta com email e senha
    /// - Parameters:
    ///   - name: Nome do usuário
    ///   - email: Email do usuário
    ///   - password: Senha do usuário
    /// - Returns: true se registro bem-sucedido, false caso contrário
    func signUp(name: String, email: String, password: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            // Cria o usuário no Firebase Auth
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            // Cria o perfil do usuário no Firestore
            let user = User(
                id: result.user.uid,
                name: name,
                email: email,
                createdAt: Date()
            )
            
            try await saveUserData(user: user)
            
            currentUser = user
            isAuthenticated = true
            isLoading = false
            return true
        } catch {
            errorMessage = handleAuthError(error)
            isLoading = false
            return false
        }
    }
    
    // MARK: - Google Sign In
    
    /// Realiza login com Google
    /// - Parameter idToken: Token de ID do Google
    /// - Parameter accessToken: Token de acesso do Google
    /// - Returns: true se login bem-sucedido, false caso contrário
    func signInWithGoogle(idToken: String, accessToken: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            let result = try await Auth.auth().signIn(with: credential)
            
            // Verifica se o usuário já existe no Firestore
            let userDoc = try await db.collection("users").document(result.user.uid).getDocument()
            
            if userDoc.exists {
                // Usuário existe, apenas carrega os dados
                await loadUserData(userId: result.user.uid)
            } else {
                // Novo usuário, cria o perfil
                let name = result.user.displayName ?? "Usuário"
                let email = result.user.email ?? ""
                let profileImageURL = result.user.photoURL?.absoluteString
                
                let user = User(
                    id: result.user.uid,
                    name: name,
                    email: email,
                    profileImageURL: profileImageURL,
                    createdAt: Date()
                )
                
                try await saveUserData(user: user)
                currentUser = user
            }
            
            await updateLastLogin(userId: result.user.uid)
            isAuthenticated = true
            isLoading = false
            return true
        } catch {
            errorMessage = handleAuthError(error)
            isLoading = false
            return false
        }
    }
    
    // MARK: - Sign Out
    
    /// Realiza logout do usuário
    func signOut() async {
        do {
            try Auth.auth().signOut()
            currentUser = nil
            isAuthenticated = false
            errorMessage = nil
        } catch {
            errorMessage = "Erro ao fazer logout: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Password Reset
    
    /// Envia email de redefinição de senha
    /// - Parameter email: Email do usuário
    /// - Returns: true se email enviado com sucesso, false caso contrário
    func resetPassword(email: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            isLoading = false
            return true
        } catch {
            errorMessage = handleAuthError(error)
            isLoading = false
            return false
        }
    }
    
    // MARK: - User Data Management
    
    /// Carrega os dados do usuário do Firestore
    private func loadUserData(userId: String) async {
        do {
            let document = try await db.collection("users").document(userId).getDocument()
            
            if let data = document.data() {
                currentUser = User.fromDictionary(data, id: userId)
            }
        } catch {
            print("❌ Erro ao carregar dados do usuário: \(error.localizedDescription)")
        }
    }
    
    /// Salva os dados do usuário no Firestore
    private func saveUserData(user: User) async throws {
        let userData = user.toDictionary()
        try await db.collection("users").document(user.id).setData(userData, merge: true)
    }
    
    /// Atualiza o último login do usuário
    private func updateLastLogin(userId: String) async {
        do {
            try await db.collection("users").document(userId).updateData([
                "lastLoginAt": FirestoreTimestamp(date: Date())
            ])
        } catch {
            print("⚠️ Erro ao atualizar último login: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Error Handling
    
    /// Trata erros de autenticação e retorna mensagens amigáveis
    private func handleAuthError(_ error: Error) -> String {
        if let authError = error as NSError? {
            switch authError.code {
            case AuthErrorCode.wrongPassword.rawValue:
                return "Senha incorreta. Tente novamente."
            case AuthErrorCode.userNotFound.rawValue:
                return "Usuário não encontrado. Verifique o email."
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                return "Este email já está em uso."
            case AuthErrorCode.weakPassword.rawValue:
                return "A senha é muito fraca. Use uma senha mais forte."
            case AuthErrorCode.invalidEmail.rawValue:
                return "Email inválido. Verifique o formato."
            case AuthErrorCode.networkError.rawValue:
                return "Erro de conexão. Verifique sua internet."
            case AuthErrorCode.tooManyRequests.rawValue:
                return "Muitas tentativas. Tente novamente mais tarde."
            default:
                return "Erro ao autenticar: \(error.localizedDescription)"
            }
        }
        return "Erro desconhecido: \(error.localizedDescription)"
    }
}


