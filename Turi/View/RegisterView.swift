//
//  RegisterView.swift
//  Turi
//
//  Created by Andre Luiz Tonon on 12/10/25.
//

internal import SwiftUI

struct RegisterView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    var body: some View {
        
        ZStack {
            // BackGround
            Color("ColorBackground")
            
            // Verificar os Espaçamentos e o placeholder
            VStack (spacing: 20){
                Text("Cadastre-se")
                    .font(.custom("Inknut Antiqua", size: 32))
                    .foregroundStyle(.white)
//                    .font(.system(size: 32))
                
                ZStack(alignment: .leading) {
                    if name.isEmpty {
                        Text("Nome:")
                            .foregroundStyle(.white.opacity(1.0))
                            .padding(.leading, 40)
                    }
                    TextField("", text: $name)
                        .padding()
                        .background(Color.clear)
                        .overlay(RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.white, lineWidth: 1)
                        )
                        .padding(.horizontal, 24)
                }
                
                
                ZStack(alignment: .leading) {
                    if email.isEmpty {
                        Text("e-mail:")
                            .foregroundStyle(.white.opacity(1.0))
                            .padding(.leading, 40)
                    }
                    TextField("", text: $email)
                        .padding()
                        .background(Color.clear)
                        .overlay(RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.white, lineWidth: 1)
                        )
                        .padding(.horizontal, 24)
                }
                
                
                // Como colocar a figura do olho ao lado
                ZStack(alignment: .leading) {
                    if password.isEmpty {
                        Text("senha:")
                            .foregroundStyle(.white.opacity(1.0))
                            .padding(.leading, 40)
                    }
                    TextField("", text: $password)
                        .padding()
                        .background(Color.clear)
                        .overlay(RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.white, lineWidth: 1)
                        )
                        .padding(.horizontal, 24)
                }
                
                TextField("confirme sua senha:", text: $confirmPassword)
                    .padding()
                    .background(Color.clear)
                    .overlay(RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.white, lineWidth: 1)
                            )
                    .padding(.horizontal, 24)
              
                VStack(alignment: .leading) {
                    HStack (spacing: 10){
                        
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                            .font(.system(size: 12, weight: .bold))
                        
                        Text("ao menos 8 caracteres")
                            .foregroundStyle(.white)
                            .font(.system(size: 12, weight: .light))
                            Spacer()
                    }
                    .padding(.horizontal, 40)
                    
                    HStack (spacing: 10){
                        
                        Image(systemName: "checkmark")
                            .foregroundStyle(.white)
                            .font(.system(size: 12, weight: .bold))
                        
                        Text("uma letra")
                            .foregroundStyle(.white.opacity(0.5))
                            .font(.system(size: 12, weight: .light))
                            Spacer()
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 1)
                    
                    HStack (spacing: 10){
                        
                        Image(systemName: "checkmark")
                            .foregroundStyle(.white)
                            .font(.system(size: 12, weight: .bold))
                        
                        Text("um número")
                            .foregroundStyle(.white.opacity(0.5))
                            .font(.system(size: 12, weight: .light))
                            Spacer()
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 1)
                }
                
                // Botão
                 Button(action: {
                print("Botão de login clicado")
            }) {
                Text("Entrar")
                    .foregroundStyle(.colorBackground)
                    .font(.custom("InknutAntiqua", size: 24))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(40)
                    .padding(.horizontal, 30)
            }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    RegisterView()
}
