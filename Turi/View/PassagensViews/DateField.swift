//
//  DateField.swift
//  Turi
//
//  Created by Leonardo Macedo on 19/10/25.
//

import SwiftUI

struct DateField: View {
    var title: String
    @Binding var date: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.custom("InknutAntiqua-Regular", size: 12))
                .foregroundColor(Color("FontBackground"))
                .font(.system(size: 14))

            DatePicker("", selection: $date, displayedComponents: .date)
                .font(.custom("InknutAntiqua-Regular", size: 12))
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
