//
//  AuthViewModel.swift
//  Turi
//
//  Created on 2025.
//

import Foundation
import SwiftUI

/// ViewModel para gerenciar o estado de autenticação na UI
@MainActor
class AuthViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var name: String = ""
    
    @Published var emailError: String?
    @Published var passwordError: String?
    @Published var confirmPasswordError: String?
    @Published var nameError: String?
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    private let authService = AuthService.shared
    
    // MARK: - Validation
    
    /// Valida o campo de email
    func validateEmail() -> Bool {
        emailError = nil
        
        if email.isEmpty {
            emailError = "Email é obrigatório"
            return false
        }
        
        if !ValidationUtils.isValidEmail(email) {
            emailError = "Email inválido"
            return false
        }
        
        return true
    }
    
    /// Valida o campo de senha
    func validatePassword() -> Bool {
        passwordError = nil
        
        if password.isEmpty {
            passwordError = "Senha é obrigatória"
            return false
        }
        
        let validation = ValidationUtils.validatePassword(password)
        if !validation.isValid {
            passwordError = validation.errorMessage
            return false
        }
        
        return true
    }
    
    /// Valida o campo de confirmação de senha
    func validateConfirmPassword() -> Bool {
        confirmPasswordError = nil
        
        if confirmPassword.isEmpty {
            confirmPasswordError = "Confirme sua senha"
            return false
        }
        
        if !ValidationUtils.passwordsMatch(password, confirmPassword) {
            confirmPasswordError = "As senhas não coincidem"
            return false
        }
        
        return true
    }
    
    /// Valida o campo de nome
    func validateName() -> Bool {
        nameError = nil
        
        if name.isEmpty {
            nameError = "Nome é obrigatório"
            return false
        }
        
        if !ValidationUtils.isValidName(name) {
            nameError = "Nome deve ter entre 2 e 50 caracteres"
            return false
        }
        
        return true
    }
    
    /// Valida todos os campos do formulário de login
    func validateLoginForm() -> Bool {
        let emailValid = validateEmail()
        let passwordValid = validatePassword()
        
        return emailValid && passwordValid
    }
    
    /// Valida todos os campos do formulário de registro
    func validateRegisterForm() -> Bool {
        let nameValid = validateName()
        let emailValid = validateEmail()
        let passwordValid = validatePassword()
        let confirmPasswordValid = validateConfirmPassword()
        
        return nameValid && emailValid && passwordValid && confirmPasswordValid
    }
    
    // MARK: - Authentication Actions
    
    /// Realiza login com email e senha
    func signIn() async -> Bool {
        guard validateLoginForm() else {
            showError = true
            return false
        }
        
        isLoading = true
        errorMessage = nil
        showError = false
        
        let success = await authService.signIn(email: email, password: password)
        
        if !success {
            errorMessage = authService.errorMessage
            showError = true
        }
        
        isLoading = false
        return success
    }
    
    /// Cria uma nova conta
    func signUp() async -> Bool {
        guard validateRegisterForm() else {
            showError = true
            return false
        }
        
        isLoading = true
        errorMessage = nil
        showError = false
        
        let success = await authService.signUp(name: name, email: email, password: password)
        
        if !success {
            errorMessage = authService.errorMessage
            showError = true
        }
        
        isLoading = false
        return success
    }
    
    /// Envia email de redefinição de senha
    func resetPassword() async -> Bool {
        guard validateEmail() else {
            showError = true
            return false
        }
        
        isLoading = true
        errorMessage = nil
        showError = false
        
        let success = await authService.resetPassword(email: email)
        
        if !success {
            errorMessage = authService.errorMessage
            showError = true
        }
        
        isLoading = false
        return success
    }
    
    // MARK: - Clear Errors
    
    /// Limpa todos os erros
    func clearErrors() {
        emailError = nil
        passwordError = nil
        confirmPasswordError = nil
        nameError = nil
        errorMessage = nil
        showError = false
    }
    
    /// Limpa todos os campos
    func clearFields() {
        email = ""
        password = ""
        confirmPassword = ""
        name = ""
        clearErrors()
    }
}

