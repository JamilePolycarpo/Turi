//
//  SettingsView.swift
//  Turi
//
//  Created by Jamile Marian Polycarpo on 03/10/25.
//

internal import SwiftUI

struct SettingsView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        ZStack {
            Color("ColorBackground")
                .ignoresSafeArea(edges: .all)
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(edges: .all)
            VStack(alignment: .leading) {
                Text("Ajustes")
                    .foregroundStyle(.white)
                    .font(.system(size: 32))
                    .padding(.horizontal, 30)
                    .padding(.top, -100)
                VStack{
                    Image(systemName: "person.circle")
                        .foregroundStyle(.white)
                        .fontWeight(.ultraLight)
                        .font(.system(size: 195))
                        .padding(.horizontal, 100)
                        .padding(.top, -30)
                    
                }
                VStack (alignment: .leading){
                    Text("Nome")
                        .foregroundStyle(.white)
                        .font(.system(size: 12))
                        .fontWeight(.light)
                        .padding(.leading, 40)
                    
                    TextField("Beltrano de Tal", text: $name)
                        .padding()
                        .foregroundStyle(.white)
                        .background(Color.clear)
                        .overlay(RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.white, lineWidth: 1))
                        .padding(.horizontal, 24)
                    
                    Text("E-mail")
                        .foregroundStyle(.white)
                        .font(.system(size: 12))
                        .fontWeight(.light)
                        .padding(.leading, 40)
                        .padding(.top, 1)
                    
                    TextField("beltrano@gmail.com", text: $email)
                        .padding()
                        .foregroundStyle(.white)
                        .background(Color.clear)
                        .overlay(RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.white, lineWidth: 1))
                        .padding(.horizontal, 24)
                    
                    Text("Senha")
                        .foregroundStyle(.white)
                        .font(.system(size: 12))
                        .fontWeight(.light)
                        .padding(.leading, 40)
                        .padding(.top, 1)
                    
                    TextField("********", text: $password)
                        .padding()
                        .foregroundStyle(.white)
                        .background(Color.clear)
                        .overlay(RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.white, lineWidth: 1))
                        .padding(.horizontal, 24)
                        .padding(.bottom, 25)
                    
                    Button(action: {
                                print("Usuário saiu do app")
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "rectangle.portrait.and.arrow.forward")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.colorBackground)
                                    Text("Sair do app")
                                        .foregroundColor(.colorBackground)
                                        .font(.custom("Inknut Antiqua", size: 12))
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(40)
                                .overlay(RoundedRectangle(cornerRadius: 40)
                                    .stroke(Color.white, lineWidth: 1))
                                .padding(.horizontal, 24)

                            }
                }
            }
        }
    }
}
#Preview {
    SettingsView()
}
