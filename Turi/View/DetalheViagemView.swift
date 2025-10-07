//
//  DetalheViagemView.swift
//  Turi
//
//  Created by Jamile Marian Polycarpo on 07/10/25.
//

internal import SwiftUI

struct DetalheViagemView: View {
    var trip: Trip

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color("ColorBackground").ignoresSafeArea()
                Image("background")
                    .resizable()
                    .scaledToFill()
                    
                
                VStack(spacing: 20) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color("FontBackground"))
                            .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.8)
                        VStack{
                            Text(trip.nome) // usando o parâmetro
                                .font(.system(size: 32, weight: .bold))
                                .foregroundStyle(Color("ColorBackground"))
                                .frame(maxWidth: .infinity, alignment: .init(horizontal: .center, vertical: .top))
                                .padding()
                            Text(trip.notas ?? "Sem notas")
                                .foregroundStyle(Color("ColorBackground"))
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
            }.ignoresSafeArea(edges: .all)
            
        }
    }
}
#Preview {
    DetalheViagemView(trip: Trip(nome: "São Paulo", data: Date(), notas: "kjbkjjbkjbkbvkjabjdbskj;kja;vjvanckajnkjf;kabgekjrggqgerg"))
       
}
