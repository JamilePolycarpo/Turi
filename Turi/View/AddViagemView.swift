internal import SwiftUI

struct AddViagemView: View {
    @State private var nome: String = ""
    @State private var dataViagem: Date = Date().addingTimeInterval(86400) // Amanhã
    @State private var notas: String = ""
    @State private var showingDatePicker = false
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viagemVM: ViagemViewModel
    @Binding var hideTabBar: Bool

    private var canSave: Bool {
        !nome.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack {
                        
                        Text("Nova Viagem")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color("FontBackground"))
                        
                        Text("Planeje sua próxima aventura")
                            .font(.subheadline)
                            .foregroundColor(Color("FontBackground").opacity(0.8))
                    }.padding(.top, 25)
                        
                    
                    // Formulário
                    VStack(spacing: 20) {
                        // Nome da viagem
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Nome da Viagem", systemImage: "airplane")
                                .font(.headline)
                                .foregroundColor(Color("FontBackground"))
                            
                            TextField("Ex: Viagem para Paris", text: $nome)
                                .padding(16)
                                .background(Color("FontBackground"))
                                .cornerRadius(40)
                                .foregroundColor(Color("ColorBackground"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(canSave ? Color.clear : Color.red.opacity(0.5), lineWidth: 1)
                                )
                        }
                        
                        // Data da viagem
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Data da Viagem", systemImage: "calendar")
                                .font(.headline)
                                .foregroundColor(Color("FontBackground"))
                            
                            Button(action: { showingDatePicker.toggle() }) {
                                HStack {
                                    Text(dataViagem.formatted(date: .abbreviated, time: .omitted))
                                        .foregroundColor(Color("ColorBackground"))
                                    Spacer()
                                    Image(systemName: "calendar")
                                        .foregroundColor(Color("ColorBackground"))
                                }
                                .padding(16)
                                .background(Color("FontBackground"))
                                .cornerRadius(40)
                            }
                            .sheet(isPresented: $showingDatePicker) {
                                VStack {
                                    DatePicker(
                                        "Data da Viagem",
                                        selection: $dataViagem,
                                        in: Date()...,
                                        displayedComponents: .date
                                    )
                                    .datePickerStyle(.wheel)
                                    .padding()
                                    
                                    Button("Confirmar") {
                                        showingDatePicker = false
                                    }
                                    .padding()
                                    .background(Color("ColorBackground"))
                                    .foregroundColor(Color("FontBackground"))
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                                }
                                .presentationDetents([.medium])
                            }
                        }
                        
                        // Notas
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Notas (Opcional)", systemImage: "note.text")
                                .font(.headline)
                                .foregroundColor(Color("FontBackground"))
                            
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $notas)
                                    .scrollContentBackground(.hidden)
                                    .frame(minHeight: 100)
                                    .padding(12)
                                    .background(Color("FontBackground"))
                                    .cornerRadius(12)
                                    .foregroundColor(Color("ColorBackground"))
                                
                                if notas.isEmpty {
                                    Text("Adicione suas notas sobre a viagem...")
                                        .foregroundColor(.gray.opacity(0.6))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 20)
                                }
                            }
                        }.frame(height: geo.size.height * 0.4)
                    }
                    .padding(.horizontal, 20)
                 
                    
                    // Botão salvar
                    VStack(spacing: 12) {
                        Button {
                            if canSave {
                                viagemVM.addViagem(nome: nome, data: dataViagem, notas: notas)
                                dismiss()
                            }
                        } label: {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Salvar Viagem")
                            }
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("ColorBackground"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(canSave ? Color("FontBackground") : Color("FontBackground").opacity(0.5))
                            .cornerRadius(40)
                        }
                        .disabled(!canSave)
                        .padding(.horizontal, 20)
                        
                        if !canSave {
                            Text("Por favor, digite um nome para a viagem")
                                .font(.caption)
                                .foregroundColor(Color("FontBackground"))
                                .padding(.horizontal, 20)
                        }
                    }
                }
            }
            .background(
                ZStack {
                    Color("ColorBackground").ignoresSafeArea()
                    Image("background")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                }
            )
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack {
                            Image(systemName: "chevron.backward")
                            Text("Voltar")
                        }
                        .foregroundColor(Color("FontBackground"))
                    }
                }
            }
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                hideTabBar = true
            }
            .onDisappear {
                hideTabBar = false
            }
        }
    }
}

#Preview {
    AddViagemView(hideTabBar: .constant(false))
        .environmentObject(ViagemViewModel())
}
