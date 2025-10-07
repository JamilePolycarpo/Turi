//
//  MapsView.swift
//  Turi
//
//  Created by Jamile Marian Polycarpo on 03/10/25.
//

internal import SwiftUI

struct MapsView: View {
    var body: some View {
        ZStack {
            Color("ColorBackground")
                .ignoresSafeArea(edges: .all)
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(edges: .all)
            Text("MapsView")
        }
    }
}

#Preview {
    MapsView()
}
