//
//  DateField.swift
//  Turi
//
//  Created by Leonardo Macedo on 19/10/25.
//

internal import SwiftUI

struct DateField: View {
    var title: String
    @Binding var date: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 14))

            DatePicker("", selection: $date, displayedComponents: .date)
                .labelsHidden()
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white, lineWidth: 1)
                )
                .accentColor(.white)
                .colorScheme(.dark)
        }
    }
}
