//
//  HomeView.swift
//  Turi
//
//  Created by Andre Luiz Tonon on 07/10/25.
//

import SwiftUI
import UIKit


struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var hideTabBar = true
    @Binding var isLoggedIn: Bool
    @State private var goToRegister: Bool = false
    
    
    var body: some View {
        ZStack {
            Color("ColorBackground")
                .ignoresSafeArea(edges: .all)
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(edges: .all)
            
            VStack(alignment: .center, spacing: 20) {
                // Título com espaçamento ajustado
                Text("Tenha o mundo nas suas mãos")
                    .font(.system(size: 32))
                    .foregroundStyle(Color("FontBackground"))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 24)
                
                // Subtítulo "Login"
                CompactText(
                    text: "Login",
                    fontSize: 28,
                    lineHeightMultiple: 0.7, // 👈 espaçamento mais próximo aqui também
                    textColor: Color("FontBackground"),
                    numberOfLines: 1,
                    alignment: .center
                )
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 24)
                
                // Campo de e-mail
                TextField("E-mail:", text: $email)
                    .padding()
                    .foregroundStyle(Color("FontBackground"))
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.white, lineWidth: 1)
                    )
                    .padding(.horizontal, 24)
                
                // Campo de senha
                ZStack(alignment: .leading) {
                    if password.isEmpty {
                        Text("Senha:")
                            .foregroundStyle(.white.opacity(1.0))
                            .padding(.leading, 40)
                    }
                    
                    SecureField("Senha:", text: $password)
                        .padding()
                        .background(Color.clear)
                        .frame(height: 45)
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.white, lineWidth: 1)
                        )
                        .padding(.horizontal, 24)
                }
                
                Text("Esqueceu a senha?")
                    .foregroundStyle(Color("FontBackground"))
                    .font(.callout)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                // Botão de login que troca o root para TabBarView via binding
                Button(action: {
                    // Aqui você pode validar email/senha antes
                    isLoggedIn = true
                }) {
                    Text("Entrar")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .foregroundStyle(Color("ColorBackground"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color("FontBackground"))
                        .cornerRadius(40)
                        .padding(.horizontal, 30)
                }
                
                VStack(spacing: 15) {
                    Text("Entre com")
                        .foregroundStyle(Color("FontBackground"))
                        .font(.custom("InknutAntiqua-Regular", size: 18))
                        .fontWeight(.bold)
                        .padding(.bottom, -18)
                    
                    Button(action: {
                        print("Login com Google")
                    }) {
                        HStack {
                            Image("ios_light_rd_na")
                                .resizable()
                                .frame(width: 25, height: 25)
                            Text("Entrar com Google")
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                    }
                    
                    Button(action: {
                        print("Login com Apple")
                    }) {
                        HStack {
                            Image(systemName: "applelogo")
                                .font(.title2)
                            Text("Entrar com Apple")
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                    }
                }
                
                if #available(iOS 17.0, *) {
                    NavigationLink(isActive: $goToRegister) {
                        TabBarView()
                    } label: {
                        Text("Ainda não tem conta? Cadastre-se!")
                            .foregroundStyle(Color("FontBackground"))
                            .font(.system(size: 12))
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                    }
                } else {
                    Button(action: {
                        // Fallback behavior for iOS < 17
                        goToRegister = true
                    }) {
                        Text("Ainda não tem conta? Cadastre-se!")
                            .foregroundStyle(Color("FontBackground"))
                            .font(.system(size: 12))
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                    }
                    .alert("Requer iOS 17", isPresented: $goToRegister) {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text("O cadastro completo requer iOS 17 ou superior.")
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

// View de fallback para versões mais antigas do iOS
struct HomePlaceholderView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Bem-vindo ao Turi!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color("FontBackground"))
            
            Text("Esta versão requer iOS 17.0 ou superior para acessar todas as funcionalidades.")
                .font(.body)
                .foregroundColor(Color("FontBackground"))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Voltar ao Login") {
                // Ação para voltar
            }
            .padding()
            .background(Color("FontBackground"))
            .foregroundColor(Color("ColorBackground"))
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("ColorBackground"))
    }
}

#Preview {
    LoginView(isLoggedIn: .constant(false))
}
