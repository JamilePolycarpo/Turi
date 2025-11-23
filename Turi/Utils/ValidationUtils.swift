//
//  ValidationUtils.swift
//  Turi
//
//  Created on 2025.
//

import Foundation

/// Utilitários para validação de campos de formulário
struct ValidationUtils {
    
    // MARK: - Email Validation
    
    /// Valida se o email está em formato válido
    /// - Parameter email: String do email a ser validado
    /// - Returns: true se válido, false caso contrário
    static func isValidEmail(_ email: String) -> Bool {
        guard !email.isEmpty else { return false }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    
    // MARK: - Password Validation
    
    /// Valida se a senha atende aos critérios mínimos
    /// - Parameter password: String da senha a ser validada
    /// - Returns: Resultado da validação com mensagens de erro
    static func validatePassword(_ password: String) -> PasswordValidationResult {
        var errors: [String] = []
        
        // Mínimo de 8 caracteres
        if password.count < 8 {
            errors.append("A senha deve ter pelo menos 8 caracteres")
        }
        
        // Pelo menos uma letra
        let hasLetter = password.rangeOfCharacter(from: CharacterSet.letters) != nil
        if !hasLetter {
            errors.append("A senha deve conter pelo menos uma letra")
        }
        
        // Pelo menos um número
        let hasNumber = password.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil
        if !hasNumber {
            errors.append("A senha deve conter pelo menos um número")
        }
        
        return PasswordValidationResult(isValid: errors.isEmpty, errors: errors)
    }
    
    /// Verifica se duas senhas são iguais
    /// - Parameters:
    ///   - password: Primeira senha
    ///   - confirmPassword: Segunda senha para confirmação
    /// - Returns: true se são iguais, false caso contrário
    static func passwordsMatch(_ password: String, _ confirmPassword: String) -> Bool {
        return !password.isEmpty && password == confirmPassword
    }
    
    // MARK: - Name Validation
    
    /// Valida se o nome está preenchido e tem tamanho mínimo
    /// - Parameter name: String do nome a ser validado
    /// - Returns: true se válido, false caso contrário
    static func isValidName(_ name: String) -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedName.count >= 2 && trimmedName.count <= 50
    }
    
    // MARK: - Field Validation
    
    /// Verifica se um campo obrigatório está preenchido
    /// - Parameter field: String do campo a ser verificado
    /// - Returns: true se preenchido, false caso contrário
    static func isFieldNotEmpty(_ field: String) -> Bool {
        return !field.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

// MARK: - Password Validation Result

/// Resultado da validação de senha
struct PasswordValidationResult {
    let isValid: Bool
    let errors: [String]
    
    var errorMessage: String {
        return errors.joined(separator: "\n")
    }
}

