//
//  LoginView.swift
//  Turi
//
//  Created by Andre Luiz Tonon on 07/10/25.
//

internal import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    var body: some View {
        
        ZStack {
            Color.colorBackground
            
            VStack (spacing: 20) {
                Text("Tenha o mundo nas suas mãos")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                
                Text("Login")
                    .foregroundStyle(.white)
                    .font(.title)
                
                TextField("E-mail:", text: $email)
                    .padding()
                    .foregroundStyle(.white)
                    .background(Color.clear)
                    .overlay(RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.white, lineWidth: 1)
                            )
                    .padding(.horizontal, 24)
                
                TextField("Senha:", text: $password)
                    .padding()
                    .background(Color.clear)
                    .overlay(RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.white, lineWidth: 1)
                            )
                    .padding(.horizontal, 24)
                
                Text("Esqueceu a senha?")
                    .foregroundStyle(.white)
                    .font(.callout)
                    .fontWeight(.semibold)
                
                 Button(action: {
                print("Botão de login clicado")
            }) {
                Text("Entrar")
                    .foregroundStyle(.colorBackground)
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(40)
                    .padding(.horizontal, 30)
            }
                
                Text("Entre com")
                    .foregroundStyle(.white)
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                
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

                Text("Ainda não tem conta? Cadastre-se!")
                    .foregroundStyle(.white)
                    .font(.system(size: 12))
                    .fontWeight(.semibold)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    LoginView()
}
