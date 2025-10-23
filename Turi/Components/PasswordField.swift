//
//  PasswordField.swift
//  Turi
//
//  Created by Andre Luiz Tonon on 22/10/25.
//

import SwiftUI

struct PasswordField: View {
    let placeholder: String
    @Binding var text: String
    @State private var isSecure: Bool = true
    
    var body: some View {
        ZStack {
            Color("ColorBackground")
            VStack {
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .foregroundStyle(.white)
                } else {
                    TextField(placeholder, text: $text)
                        .foregroundStyle(.white)
                }
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isSecure.toggle()
                    }
                }) {
                    Image(systemName: isSecure ? "eye.slash" : "eye")
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding()
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(Color.white, lineWidth: 1)
            )
            .frame(height: 45)
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    PasswordField(placeholder: "Senha:", text: .constant(""))
        .background(Color.black)
}
