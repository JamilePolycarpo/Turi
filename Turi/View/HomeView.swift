//
//  HomeView.swift
//  Turi
//
//  Created by Jamile Marian Polycarpo on 03/10/25.
//

internal import SwiftUI
import Combine

@available(iOS 17.0, *)
struct HomeView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Binding var hideTabBar: Bool
    private let carouselImages = ["photo2", "photo3", "photo1"]
    private let carouselTitles = ["Viaje para a Bahia", "Conheça o Rio", "Explore São Paulo"]
    private let carouselDescriptions = [
        "Descubra as belezas naturais e culturais da Bahia",
        "A cidade maravilhosa com suas paisagens únicas",
        "A metrópole que nunca para"
    ]
    @State private var currentIndex: Int = 0
    @State private var isTimerActive: Bool = true
    @EnvironmentObject var viagemVM: ViagemViewModel

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    Color("ColorBackground")
                        .ignoresSafeArea(edges: .all)
                    Image("background")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea(edges: .all)
                    
                    VStack(spacing: 0) {
                        // Carrossel no topo da safe area
                        TabView(selection: $currentIndex) {
                            ForEach(Array(carouselImages.enumerated()), id: \.offset) { index, imageName in
                                ZStack(alignment: .bottomLeading) {
                                    // Imagem de fundo
                                    Image(imageName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: geo.size.width,
                                               height: geo.size.height * 0.35)
                                        .clipped()
                                    
                                    // Overlay escuro para melhor legibilidade
                                    Rectangle()
                                        .fill(Color.black.opacity(0.3))
                                        .frame(height: geo.size.height * 0.35)
                                    
                                    // Texto sobreposto
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(carouselTitles[index])
                                            .font(.system(size: min(geo.size.width * 0.06, 28), weight: .bold))
                                            .foregroundColor(.white)
                                            .shadow(color: .black, radius: 2, x: 1, y: 1)
                                        
                                        Text(carouselDescriptions[index])
                                            .font(.system(size: min(geo.size.width * 0.04, 18), weight: .medium))
                                            .foregroundColor(.white)
                                            .shadow(color: .black, radius: 1, x: 1, y: 1)
                                            .lineLimit(2)
                                    }
                                    .padding(.leading, 20)
                                    .padding(.bottom, 20)
                                }
                                .frame(width: geo.size.width,
                                       height: geo.size.height * 0.35)
                                .clipped()
                                .tag(index)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .automatic))
                        .frame(width: geo.size.width,
                               height: geo.size.height * 0.35)
                        .clipped()
                        .ignoresSafeArea(.container, edges: .top)

                        HStack {
                            Text("Sua lista de viagens")
                                .font(.system(size: min(geo.size.width * 0.08, 32), weight: .bold))
                                .foregroundStyle(Color("FontBackground"))
                            Spacer(minLength: 30)
                            NavigationLink(destination: AddViagemView(hideTabBar: $hideTabBar)) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: min(geo.size.width * 0.1, 40)))
                                    .foregroundColor(Color("FontBackground"))
                            }
                        }
                        .padding(.top, -15)
                        .padding(.horizontal, max(geo.size.width * 0.05, 20))

                        List {
                            ForEach($viagemVM.trips, id: \.id) { $trip in
                                NavigationLink(destination: DetalheViagemView(trip: $trip, hideTabBar: $hideTabBar)) {
                                    HStack(spacing: 12) {
                                        ZStack {
                                            Circle()
                                                .fill(Color("ColorBackground").opacity(0.12))
                                            Image(systemName: "airplane")
                                                .foregroundStyle(Color("ColorBackground"))
                                                .font(.system(size: 18, weight: .semibold))
                                        }
                                        .frame(width: 36, height: 36)
                                        Text(trip.nome)
                                            .font(.system(size: min(geo.size.width * 0.055, 22), weight: .semibold))
                                            .foregroundStyle(Color("ColorBackground"))
                                        Spacer()
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 14)
                                    .background(
                                        RoundedRectangle(cornerRadius: 40, style: .continuous)
                                            .fill(Color("FontBackground"))
                                    )
                                }
                                .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
                                .listRowBackground(Color.clear)
                            }
                            .onDelete(perform: viagemVM.deleteTrip)
                        }
                        .scrollContentBackground(.hidden)
                        .listStyle(.plain)
                        .padding(.top, 10)
                    }
                }
                .onChange(of: scenePhase) { _, newPhase in
                    isTimerActive = (newPhase == .active)
                }
                .onReceive(Timer.publish(every: 4, on: .main, in: .common).autoconnect()) { _ in
                    guard isTimerActive, !carouselImages.isEmpty else { return }
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentIndex = (currentIndex + 1) % carouselImages.count
                    }
                }
            }.frame(maxWidth: .infinity)
        }
    }
}
#Preview {
    if #available(iOS 17.0, *) {
        HomeView(hideTabBar: .constant(false))
            .environmentObject(ViagemViewModel())
    } else {
        // Fallback on earlier versions
    }
}
