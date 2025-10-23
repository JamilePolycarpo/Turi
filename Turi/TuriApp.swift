import SwiftUI

@main
struct TuriApp: App {
    @StateObject private var viagem = ViagemViewModel()
    @State private var showLaunchScreen: Bool = true
    @State private var isLoggedIn: Bool = false

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
                } else if isLoggedIn {
                    if #available(iOS 17.0, *) {
                        TabBarView()
                            .environmentObject(viagem)
                    } else {
                        Text("Unsupported iOS version")
                            .environmentObject(viagem)
                    }
                } else {
                    LoginView(isLoggedIn: $isLoggedIn)
                        .environmentObject(viagem)
                }
            }
        }
    }
}
