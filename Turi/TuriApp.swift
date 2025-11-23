import SwiftUI

@main
struct TuriApp: App {
    @StateObject private var viagem = ViagemViewModel()
    @StateObject private var authService = AuthService.shared
    @State private var showLaunchScreen: Bool = true
    @State private var isFirebaseConfigured: Bool = false
    
    init() {
        // Configura o Firebase na inicialização
        configureFirebase()
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if showLaunchScreen {
                    LaunchScreen()
                        .onAppear {
                            // Mostra a LaunchScreen por 2.5 segundos
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    showLaunchScreen = false
                                }
                            }
                        }
                } else if authService.isAuthenticated {
                    // Usuário autenticado - mostra a tela principal
                    if #available(iOS 17.0, *) {
                        TabBarView()
                            .environmentObject(viagem)
                            .environmentObject(authService)
                    } else {
                        Text("Unsupported iOS version")
                            .environmentObject(viagem)
                            .environmentObject(authService)
                    }
                } else {
                    // Usuário não autenticado - mostra tela de login
                    LoginView()
                        .environmentObject(viagem)
                        .environmentObject(authService)
                }
            }
        }
    }
    
    // MARK: - Firebase Configuration
    
    private func configureFirebase() {
        // Tenta configurar o Firebase
        // Se o GoogleService-Info.plist não existir, o app continuará funcionando
        // mas sem autenticação Firebase
        if FirebaseService.shared.configure() {
            isFirebaseConfigured = true
            print("✅ Firebase configurado com sucesso")
        } else {
            print("⚠️ Firebase não configurado. Adicione GoogleService-Info.plist ao projeto.")
        }
    }
}
