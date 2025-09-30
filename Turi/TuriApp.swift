//
//  TuriApp.swift
//  Turi
//
//  Created by Jamile Marian Polycarpo on 24/09/25.
//

import SwiftUI
@main
struct TuriApp: App {
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ContentView()
                .fullScreenCover(isPresented: $showSplash) {
                    LaunchScreen()
                        .task {
                            try? await Task.sleep(for: .seconds(1.5))
                            showSplash = false
                        }
                }
        }
    }
}
