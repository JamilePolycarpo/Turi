//
//  LaunchScreen.swift
//  Turi
//
//  Created by Jamile Marian Polycarpo on 26/09/25.
//

internal import SwiftUI


struct LaunchScreen: View {
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0.0
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let minSide = min(size.width, size.height)
            
            // Logo será sempre proporcional ao menor lado
            let logoWidth = minSide * 0.7
            Color("ColorBackground")
                .ignoresSafeArea(edges: .all)
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(edges: .all)
            }
            .frame(width: size.width, height: size.height)
            .overlay(alignment: .center) {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: logoWidth)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                    .shadow(radius: 6)
            }
            .onAppear {
                // Fade + scale in
                logoOpacity = 0
                logoScale = 0.8
                withAnimation(.easeOut(duration: 0.6)) {
                    logoOpacity = 1
                    logoScale = 1.0
                }
                // Pequeno pulso
                withAnimation(.easeInOut(duration: 0.4).delay(0.8)) {
                    logoScale = 1.06
                }
                withAnimation(.spring(response: 0.5, dampingFraction: 0.85).delay(1.2)) {
                    logoScale = 1.0
                }
            }
        }
    }
}

#Preview {
    LaunchScreen()
}
