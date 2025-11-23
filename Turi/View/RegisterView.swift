//
//  RegisterView.swift
//  Turi
//
//  Created by Andre Luiz Tonon on 12/10/25.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = AuthViewModel()
    @EnvironmentObject var authService: AuthService
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Background
            Color("ColorBackground")
                .ignoresSafeArea(edges: .all)
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(edges: .all)
            
            ScrollView {
                VStack(spacing: 20) {
                    // Título
                    Text("Cadastre-se")
                        .font(.custom("InknutAntiqua-Regular", size: 32))
                        .foregroundStyle(.white)
                        .padding(.top, 40)
                    
                    // Campo de nome
                    VStack(alignment: .leading, spacing: 4) {
                        ZStack(alignment: .leading) {
                            if viewModel.name.isEmpty {
                                Text("Nome:")
                                    .foregroundStyle(.white.opacity(0.7))
                                    .padding(.leading, 40)
                            }
                            TextField("", text: $viewModel.name)
                                .padding()
                                .background(Color.clear)
                                .foregroundStyle(.white)
                                .autocapitalization(.words)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(viewModel.nameError != nil ? Color.red : Color.white, lineWidth: 1)
                                )
                                .padding(.horizontal, 24)
                        }
                        
                        if let error = viewModel.nameError {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.horizontal, 40)
                        }
                    }
                    
                    // Campo de e-mail
                    VStack(alignment: .leading, spacing: 4) {
                        ZStack(alignment: .leading) {
                            if viewModel.email.isEmpty {
                                Text("E-mail:")
                                    .foregroundStyle(.white.opacity(0.7))
                                    .padding(.leading, 40)
                            }
                            TextField("", text: $viewModel.email)
                                .padding()
                                .background(Color.clear)
                                .foregroundStyle(.white)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(viewModel.emailError != nil ? Color.red : Color.white, lineWidth: 1)
                                )
                                .padding(.horizontal, 24)
                        }
                        
                        if let error = viewModel.emailError {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.horizontal, 40)
                        }
                    }
                    
                    // Campo de senha
                    VStack(alignment: .leading, spacing: 4) {
                        ZStack(alignment: .leading) {
                            if viewModel.password.isEmpty {
                                Text("Senha:")
                                    .foregroundStyle(.white.opacity(0.7))
                                    .padding(.leading, 40)
                            }
                            SecureField("", text: $viewModel.password)
                                .padding()
                                .background(Color.clear)
                                .foregroundStyle(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(viewModel.passwordError != nil ? Color.red : Color.white, lineWidth: 1)
                                )
                                .padding(.horizontal, 24)
                        }
                        
                        if let error = viewModel.passwordError {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.horizontal, 40)
                        }
                    }
                    
                    // Campo de confirmação de senha
                    VStack(alignment: .leading, spacing: 4) {
                        ZStack(alignment: .leading) {
                            if viewModel.confirmPassword.isEmpty {
                                Text("Confirme sua senha:")
                                    .foregroundStyle(.white.opacity(0.7))
                                    .padding(.leading, 40)
                            }
                            SecureField("", text: $viewModel.confirmPassword)
                                .padding()
                                .background(Color.clear)
                                .foregroundStyle(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(viewModel.confirmPasswordError != nil ? Color.red : Color.white, lineWidth: 1)
                                )
                                .padding(.horizontal, 24)
                        }
                        
                        if let error = viewModel.confirmPasswordError {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.horizontal, 40)
                        }
                    }
                    
                    // Validações de senha
                    if !viewModel.password.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            PasswordRequirement(
                                isValid: viewModel.password.count >= 8,
                                text: "ao menos 8 caracteres"
                            )
                            
                            PasswordRequirement(
                                isValid: viewModel.password.rangeOfCharacter(from: CharacterSet.letters) != nil,
                                text: "uma letra"
                            )
                            
                            PasswordRequirement(
                                isValid: viewModel.password.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil,
                                text: "um número"
                            )
                        }
                        .padding(.horizontal, 40)
                    }
                    
                    // Mensagem de erro geral
                    if viewModel.showError, let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                    
                    // Loading indicator
                    if viewModel.isLoading {
                        ProgressView("Criando conta...")
                            .padding(.horizontal, 24)
                    }
                    
                    // Botão de cadastro
                    Button(action: {
                        Task {
                            let success = await viewModel.signUp()
                            if success {
                                dismiss()
                            }
                        }
                    }) {
                        Text("Cadastrar")
                            .font(.custom("InknutAntiqua-Regular", size: 24))
                            .foregroundStyle(Color("ColorBackground"))
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color("FontBackground"))
                            .cornerRadius(50)
                            .padding(.horizontal, 30)
                    }
                    .disabled(viewModel.isLoading || !viewModel.validateRegisterForm())
                    .opacity((viewModel.isLoading || !viewModel.validateRegisterForm()) ? 0.5 : 1)
                    
                    // Botão de voltar
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Já tem conta? Faça login")
                            .foregroundStyle(.white)
                            .font(.system(size: 12))
                            .fontWeight(.semibold)
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Password Requirement View

struct PasswordRequirement: View {
    let isValid: Bool
    let text: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: isValid ? "checkmark" : "xmark")
                .foregroundStyle(isValid ? .green : .white)
                .font(.system(size: 12, weight: .bold))
            
            Text(text)
                .foregroundStyle(isValid ? .white.opacity(0.7) : .white.opacity(0.5))
                .font(.system(size: 12, weight: .light))
            
            Spacer()
        }
    }
}

#Preview {
    RegisterView()
        .environmentObject(AuthService.shared)
}
