internal import SwiftUI

struct AddViagemView: View {
    @State private var nome: String = ""
    @State private var notas: String = ""
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viagemVM: ViagemViewModel

    private var canSave: Bool {
        !nome.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: geo.size.height * 0.03) {
                    // 🔹 Título
                    Text("Adicionar Viagem")
                        .font(.system(size: geo.size.width < 500 ? 28 : 40, weight: .bold))
                        .foregroundColor(Color("FontBackground"))
                        .padding(.top, geo.safeAreaInsets.top + 16)

                    // 🔹 Campo de texto — nome
                    TextField("Nome da Viagem", text: $nome)
                        .padding()
                        .background(Color("FontBackground"))
                        .cornerRadius(40)
                        .foregroundColor(Color("ColorBackground"))
                        .padding(.horizontal, 24)

                    // 🔹 Campo de texto — notas
                    Text("Notas")
                        .font(.title2)
                        .foregroundColor(Color("FontBackground"))

                    TextEditor(text: $notas)
                        .frame(height: geo.size.height * 0.25)
                        .scrollContentBackground(.hidden)
                        .background(Color("FontBackground"))
                        .cornerRadius(12)
                        .padding(.horizontal, 24)

                    // 🔹 Botão salvar
                    Button {
                        if canSave {
                            viagemVM.addViagem(nome: nome, notas: notas)
                            nome = ""
                            notas = ""
                            dismiss()
                        }
                    } label: {
                        Text("Salvar")
                            .font(.title2)
                            .bold()
                            .foregroundColor(Color("ColorBackground"))
                            .padding(.horizontal, 40)
                            .padding(.vertical, 14)
                            .background(Color("FontBackground"))
                            .cornerRadius(50)
                    }
                    .opacity(canSave ? 1 : 0.5)
                    .disabled(!canSave)

                    Spacer(minLength: geo.size.height * 0.1)
                }
                .frame(maxWidth: .infinity)
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
                        Label("Voltar", systemImage: "chevron.backward")
                            .foregroundColor(Color("FontBackground"))
                    }
                }
            }
        }
    }
}

#Preview {
    AddViagemView()
        .environmentObject(ViagemViewModel())
}
