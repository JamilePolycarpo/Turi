//
//  RoundedTextField.swift
//  Turi
//
//  Created by Leonardo Macedo on 19/10/25.
//

import SwiftUI

struct RoundedTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .font(.custom("InknutAntiqua-Regular", size: 12))
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .font(.subheadline)
            .foregroundColor(Color("FontBackground"))
            .background(Color("FontBackground").opacity(0.05))
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color("FontBackground").opacity(0.7), lineWidth: 1)
            )
            .cornerRadius(30)
    }
}
