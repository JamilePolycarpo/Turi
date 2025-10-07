internal import SwiftUI

@main
struct TuriApp: App {
    @StateObject private var viagem = ViagemViewModel()

    var body: some Scene {
        WindowGroup {
            GeometryReader { geo in
                // Usamos GeometryReader para capturar o tamanho real da janela
                let width = geo.size.width
                let height = geo.size.height
                let isCompact = width < 600 // iPhone vs iPad
                
                ZStack{
                    HomeView()
                        .environmentObject(viagem)
                    
                    
                   /* TabBarView()
                        .environmentObject(viagem)
                    // Adapta margens conforme o dispositivo
                        .padding(.horizontal, isCompact ? 0 : 24)
                        .padding(.vertical, isCompact ? 0 : 12)
                    // Redimensiona fontes dinamicamente
                        .environment(\.dynamicTypeSize, isCompact ? .medium : .xxxLarge)
                        .frame(width: width, height: height)
                    // Usa o fundo global
                        .background(
                            ZStack {
                                Color("ColorBackground")
                                    .ignoresSafeArea()
                                Image("background")
                                    .resizable()
                                    .scaledToFill()
                                    .ignoresSafeArea()
                            }
                        )*/
                        .preferredColorScheme(.light)
                }
            }
        }
    }
}
