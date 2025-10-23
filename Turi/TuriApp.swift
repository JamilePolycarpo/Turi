internal import SwiftUI

@main
struct TuriApp: App {
    @StateObject private var viagem = ViagemViewModel()

 
    var body: some Scene {
        WindowGroup {
           // GeometryReader { geo in
                // Usamos GeometryReader para capturar o tamanho real da janela
               
                
               // ZStack{
                //    HomeView()
                  //      .environmentObject(viagem)
                    
                   // Spacer()
            if #available(iOS 17.0, *) {
                TabBarView()
                    .environmentObject(viagem)
            } else {
                // Fallback for earlier iOS versions
                // Replace `HomeView()` with an appropriate fallback view if available
                Text("Unsupported iOS version")
                    .environmentObject(viagem)
            }
                       // Adapta margens conforme o dispositivo
                       // .padding(.horizontal, isCompact ? 0 : 24)
                       //.padding(.vertical, isCompact ? 0 : 12)
                    // Redimensiona fontes dinamicamente
                        //.environment(\.dynamicTypeSize, isCompact ? .medium : .xxxLarge)
                
                       // .frame(width: width, height: 200)
                    // Usa o fundo global
                       /* .background(
                            ZStack {
                                Color("ColorBackground")
                                    .ignoresSafeArea()
                                Image("background")
                                    .resizable()
                                    .scaledToFill()
                                    .ignoresSafeArea()
                            }
                        )*/
                       // .preferredColorScheme(.light)
                //}.background(.blue)
           // }
        }
    }
}
