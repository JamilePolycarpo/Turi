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
                    .padding()
                VStack{
                    Image(systemName: "person.circle")
                        .foregroundStyle(.white)
                        .fontWeight(.ultraLight)
                        .font(.system(size: 195))
                    
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
                        .padding(.top)
                    
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
                        .padding(.top)
                    
                    TextField("********", text: $password)
                        .padding()
                        .foregroundStyle(.white)
                        .background(Color.clear)
                        .overlay(RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.white, lineWidth: 1))
                        .padding(.horizontal, 24)
                }
                
            }
           
            
            
            
        }
    }
}
#Preview {
    SettingsView()
}
