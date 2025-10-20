//
//  RoundedTextField.swift
//  Turi
//
//  Created by Leonardo Macedo on 19/10/25.
//

internal import SwiftUI

struct RoundedTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .font(.subheadline)
            .foregroundColor(.white)
            .background(Color.white.opacity(0.05))
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.white.opacity(0.7), lineWidth: 1)
            )
            .cornerRadius(30)
    }
}
