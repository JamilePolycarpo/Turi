//
//  RegisterView.swift
//  Turi
//
//  Created by Andre Luiz Tonon on 12/10/25.
//

import SwiftUI

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
                
                ZStack(alignment: .leading) {
                    if confirmPassword.isEmpty {
                        Text("confirme sua senha:")
                            .foregroundStyle(.white.opacity(1.0))
                            .padding(.leading, 40)
                    }
                    TextField("", text: $confirmPassword)
                        .padding()
                        .background(Color.clear)
                        .overlay(RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.white, lineWidth: 1)
                        )
                        .padding(.horizontal, 24)
                }
              
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
                            .padding(.top, -5)
                        
                        Text("uma letra")
                            .foregroundStyle(.white.opacity(0.5))
                            .font(.system(size: 12, weight: .light))
                            .padding(.top, -5)
                            Spacer()
                    }
                    .padding(.horizontal, 40)
                    
                    HStack (spacing: 10){
                        
                        Image(systemName: "checkmark")
                            .foregroundStyle(.white)
                            .font(.system(size: 12, weight: .bold))
                            .padding(.top, -5)
                        
                        Text("um número")
                            .foregroundStyle(.white.opacity(0.5))
                            .font(.system(size: 12, weight: .light))
                            .padding(.top, -5)
                            Spacer()
                    }
                    .padding(.horizontal, 40)
                }
                
                // Botão

                if #available(iOS 17.0, *) {
                    NavigationLink {
                        // TODO: Inject real bindings/environment objects when wiring navigation
                        HomeView(hideTabBar: .constant(false), viagemVM: .init())
                    } label: {
                        Text("Entrar")
                            .font(.custom("InknutAntiqua-Regular", size: 24))
                            .foregroundStyle(Color("ColorBackground"))
                            .frame(maxWidth: .infinity)
                            .background(Color("FontBackground"))
                            .cornerRadius(50)
                            .padding(.horizontal, 30)
                    }
                } else {
                    // Fallback for earlier iOS versions
                    Button(action: {}) {
                        Text("Entrar")
                            .foregroundStyle(.colorBackground)
                            .font(.custom("InknutAntiqua", size: 24))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.6))
                            .cornerRadius(40)
                            .padding(.horizontal, 30)
                    }
                    .disabled(true)
                }


            }
            
        }
        .ignoresSafeArea()
    }
}

#Preview {
    RegisterView()
}
