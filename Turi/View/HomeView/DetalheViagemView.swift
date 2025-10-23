//
//  DetalheViagemView.swift
//  Turi
//
//  Created by Jamile Marian Polycarpo on 07/10/25.
//

import SwiftUI

struct DetalheViagemView: View {
    @Binding var trip: Trip
    @EnvironmentObject private var viagemVM: ViagemViewModel
    @Binding var hideTabBar: Bool
    
    @State private var isEditing = false
    @State private var draftName: String = ""
    @State private var draftNotes: String = ""
    @State private var draftDate: Date = Date()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background
                Color("ColorBackground")
                    .ignoresSafeArea()
                
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                ScrollView {
                    Spacer(minLength: geo.size.width * 0.09)
                    VStack(alignment: .center, spacing: 20) {
                        // Ícone do estado de São Paulo (simulado)
                        Image(systemName: "map")
                            .font(.system(size: 40, weight: .semibold))
                            .foregroundColor(Color("ColorBackground"))
                        
                         if isEditing {
                             TextField("Nome da viagem", text: $draftName)
                                 .font(.custom("InknutAntiqua-SemiBold",size: min(geo.size.width * 0.09, 36)))
                                 .multilineTextAlignment(.center)
                                 .foregroundColor(Color("ColorBackground"))
                                 .padding(.horizontal, max(geo.size.width * 0.08, 30))
                                 .padding(.vertical, 15)
                                 .background(Color("FontBackground"))
                                 .cornerRadius(25)
                         } else {
                             Text(trip.nome)
                                 .font(.custom("InknutAntiqua-Regular",size: min(geo.size.width * 0.09, 32)))
                                 .foregroundColor(Color("ColorBackground"))
                                 .multilineTextAlignment(.center)
                                 
                         }
                         
                         // Informações da data e status
                        VStack(spacing: 15) {
                            // Primeira linha: Data e Status lado a lado
                            HStack(spacing: 15) {
                                // Data da viagem
                                VStack(spacing: 8) {
                                    Image(systemName: "calendar")
                                        .foregroundColor(Color("ColorBackground"))
                                        .font(.system(size: 20, weight: .semibold))
                                    
                                    if isEditing {
                                        DatePicker("", selection: Binding(
                                            get: { draftDate },
                                            set: { draftDate = $0 }
                                        ), displayedComponents: .date)
                                        .datePickerStyle(.compact)
                                        .labelsHidden()
                                    } else {
                                         Text(trip.formattedDate)
                                             .font(.system(size: 14, weight: .medium))
                                             .foregroundColor(Color("ColorBackground"))
                                    }
                                }
                                 .frame(width: geo.size.width * 0.22)
                                 .padding(.vertical, 12)
                                 .background(
                                     RoundedRectangle(cornerRadius: 12)
                                         .fill(Color("FontBackground"))
                                         .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                                 )
                                 
                                 // Status da viagem
                                 VStack(spacing: 6) {
                                     Image(systemName: trip.isUpcoming ? "clock" : "checkmark.circle")
                                         .foregroundColor(trip.isUpcoming ? .orange : .green)
                                         .font(.system(size: 18, weight: .semibold))
                                     
                                     Text(trip.isUpcoming ? "Próxima Viagem" : "Viagem Realizada")
                                         .font(.system(size: 12, weight: .medium))
                                         .foregroundColor(Color("ColorBackground"))
                                         .multilineTextAlignment(.center)
                                 }
                                 .frame(width: geo.size.width * 0.18)
                                 .padding(.vertical, 12)
                                 .background(
                                     RoundedRectangle(cornerRadius: 12)
                                         .fill(Color("FontBackground"))
                                         .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                                 )
                                 
                                 // Terceiro card: Dias até a viagem ou ano da viagem passada
                                 VStack(spacing: 6) {
                                     if trip.isUpcoming {
                                         Image(systemName: "calendar.badge.clock")
                                             .foregroundColor(Color("ColorBackground"))
                                             .font(.system(size: 18, weight: .semibold))
                                         
                                         Text("Faltam \(trip.daysUntilTrip) dias")
                                             .font(.system(size: 12, weight: .medium))
                                             .foregroundColor(Color("ColorBackground"))
                                             .multilineTextAlignment(.center)
                                     } else {
                                         Image(systemName: "calendar")
                                             .foregroundColor(Color("ColorBackground"))
                                             .font(.system(size: 18, weight: .semibold))
                                         
                                         Text("Viagem: \(Calendar.current.component(.year, from: trip.data))")
                                             .font(.system(size: 12, weight: .medium))
                                             .foregroundColor(Color("ColorBackground"))
                                             .multilineTextAlignment(.center)
                                     }
                                 }
                                 .frame(width: geo.size.width * 0.18)
                                 .padding(.vertical, 12)
                                 .background(
                                     RoundedRectangle(cornerRadius: 12)
                                         .fill(Color("FontBackground"))
                                         .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                                 )
                            }
                        }
                         
                        // Seção: Anotações de To Do na Viagem
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Anotações:")
                                .font(.system(size: min(geo.size.width * 0.1, 20), weight: .bold))
                                .foregroundColor(Color("ColorBackground"))
                            
                            VStack(alignment: .leading, spacing: 10) {
                                if isEditing {
                                    TextEditor(text: $draftNotes)
                                        .scrollContentBackground(.hidden)
                                        .frame(minHeight: 120)
                                        .padding(15)
                                        .background(Color("FontBackground"))
                                        .cornerRadius(15)
                                        .foregroundColor(Color("ColorBackground"))
                                } else {
                                    if let notas = trip.notas, !notas.isEmpty {
                                        // Dividir as notas em linhas para simular lista
                                        let lines = notas.components(separatedBy: "\n")
                                        ForEach(Array(lines.enumerated()), id: \.offset) { index, line in
                                            if !line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                                HStack(alignment: .top, spacing: 12) {
                                                    Text("•")
                                                        .foregroundColor(Color("ColorBackground"))
                                                        .font(.system(size: 16, weight: .bold))
                                                    Text(line.trimmingCharacters(in: .whitespacesAndNewlines))
                                                        .foregroundColor(Color("ColorBackground"))
                                                        .font(.system(size: 16))
                                                        .multilineTextAlignment(.leading)
                                                }
                                            }
                                        }
                                    } else {
                                        HStack {
                                            Image(systemName: "checkmark.circle")
                                                .foregroundColor(Color("ColorBackground").opacity(0.6))
                                            Text("Nenhuma anotação adicionada")
                                                .foregroundColor(Color("ColorBackground").opacity(0.6))
                                                .font(.system(size: 16))
                                            Spacer()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .frame(width:geo.size.width * 0.9, height: geo.size.height * 0.75, alignment: .top)
                   
                   
                    .padding(.top, 30)
                        .background(
                            RoundedRectangle(cornerRadius: max(geo.size.width * 0.06, 25))
                                .fill(Color("FontBackground"))
                                .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 8)
                        )
                        .padding(.horizontal, max(geo.size.width * 0.05, 20))
                    
                }
               
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                         Button(isEditing ? "Concluir" : "Editar") {
                             if isEditing {
                                 let trimmedName = draftName.trimmingCharacters(in: .whitespacesAndNewlines)
                                 let trimmedNotes = draftNotes.trimmingCharacters(in: .whitespacesAndNewlines)
                                 // Atualiza no ViewModel
                                 viagemVM.updateTrip(trip, nome: trimmedName, data: draftDate, notas: trimmedNotes.isEmpty ? nil : trimmedNotes)
                                 // Atualiza a cópia local para refletir imediatamente na UI
                                 trip = Trip(
                                     nome: trimmedName,
                                     data: draftDate,
                                     notas: trimmedNotes.isEmpty ? nil : trimmedNotes
                                 )
                             } else {
                                 draftName = trip.nome
                                 draftNotes = trip.notas ?? ""
                                 draftDate = trip.data
                             }
                             withAnimation { isEditing.toggle() }
                         }
                    }
                }
                .onAppear {
                    draftName = trip.nome
                    draftNotes = trip.notas ?? ""
                    draftDate = trip.data
                    hideTabBar = true
                }
                .onDisappear {
                    hideTabBar = false
                }
                .toolbar(.hidden, for: .tabBar)
            }
        }
    }
}

#Preview("DetalheViagemView - Preview") {
    // Create a sample Trip and a State wrapper to provide a Binding
    @State var sampleTrip = Trip(nome: "São Paulo", data: Date(), notas: "Exemplo de notas da viagem")
    @State var isTabBarHidden: Bool = false

    // Provide a ViagemViewModel environment object if needed by the view
    let vm = ViagemViewModel()

    DetalheViagemView(trip: $sampleTrip, hideTabBar: $isTabBarHidden)
        .environmentObject(vm)
}
 

