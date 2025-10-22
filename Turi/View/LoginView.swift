//
//  LoginView.swift
//  Turi
//
//  Created by Andre Luiz Tonon on 07/10/25.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    var body: some View {
        
        ZStack {
            Color.colorBackground
            
            VStack (alignment: .center, spacing: 20) {
                CompactTextSwiftUI(
                    text: "Tenha o mundo nas suas mãos",
                    fontName: "InknutAntiqua-Light",
                    fontSize: 32,
                    lineHeightMultiple: 0.7,
                    textColor: Color("FontBackground"),
                    numberOfLines: 3,
                    alignment: .center,
                    shadowColor: nil
                )
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 24)
                
                CompactTextSwiftUI(
                    text: "Login",
                    fontName: "InknutAntiqua-Light",
                    fontSize: 32,
                    lineHeightMultiple: 0.7,
                    textColor: Color("FontBackground"),
                    numberOfLines: 1,
                    alignment: .center,
                    shadowColor: nil
                )
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 24)
                
                TextField("E-mail:", text: $email)
                    .padding()
                    .foregroundStyle(Color("FontBackground"))
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
                    .foregroundStyle(Color("FontBackground"))
                    .font(.callout)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                 Button(action: {
                print("Botão de login clicado")
            }) {
                Text("Entrar")
                    .foregroundStyle(Color("ColorBackground"))
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
                    .multilineTextAlignment(.center)
                
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
                    .foregroundStyle(Color("FontBackground"))
                    .font(.system(size: 12))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    LoginView()
}
