//
//  HomeView.swift
//  Turi
//
//  Created by Jamile Marian Polycarpo on 03/10/25.
//

internal import SwiftUI
import Combine

struct HomeView: View {
    @Environment(\.scenePhase) private var scenePhase
    private let carouselImages = ["photo1", "photo2", "photo3"]
    @State private var currentIndex: Int = 0
    @State private var isTimerActive: Bool = true
    @EnvironmentObject var viagemVM: ViagemViewModel
    
    var body: some View {
        NavigationStack{
            GeometryReader{ geo in
                ZStack{
                    Color("ColorBackground")
                        .ignoresSafeArea(edges: .all)
                    
                    Image("background")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea(edges: .all)
                    
                    VStack{
                        // Carousel
                        if #available(iOS 17.0, *) {
                            TabView(selection: $currentIndex) {
                                ForEach(Array(carouselImages.enumerated()), id: \.offset) { index, name in
                                    Image(name)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geo.size.width, height: geo.size.height * 0.35)
                                        .clipped()
                                        .tag(index)
                                }
                            }
                            .tabViewStyle(.page(indexDisplayMode: .automatic))
                            .frame(width: geo.size.width, height: geo.size.height * 0.35)
                            //.padding(.top, -geo.safeAreaInsets.top)
                            .ignoresSafeArea(.container, edges: .top)
                            
                            .onChange(of: scenePhase) { oldPhase, newPhase in
                                isTimerActive = (newPhase == .active)
                            }
                            .onReceive(Timer.publish(every: 3, on: .main, in: .common).autoconnect()) { _ in
                                guard isTimerActive, !carouselImages.isEmpty else { return }
                                withAnimation(.easeInOut) {
                                    currentIndex = (currentIndex + 1) % carouselImages.count
                                }
                            }
                        } else {
                            // Fallback on earlier versions
                        }
                        HStack{
                            Text("Sua Lista de Viagem")
                                .font(.system(size: 32))
                                .bold()
                                .foregroundStyle(Color("FontBackground"))
                                .padding()
                            Spacer()
                            
                            NavigationLink(destination: AddViagemView()){
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(Color("FontBackground"))
                                
                            }
                        }.padding(.horizontal, 20)
                        
                        List {
                            ForEach(viagemVM.trips, id: \.id) { trip in
                                NavigationLink {
                                    DetalheViagemView(trip: trip)
                                } label: {
                                    HStack(spacing: 12) {
                                        ZStack {
                                            Circle()
                                                .fill(Color("ColorBackground").opacity(0.12))
                                            Image(systemName: "airplane")
                                                .foregroundStyle(Color("ColorBackground"))
                                                .font(.system(size: 18, weight: .semibold))
                                        }
                                        .frame(width: 36, height: 36)

                                        Text(verbatim: trip.nome)
                                            .font(.system(size: 22, weight: .semibold))
                                            .foregroundStyle(Color("ColorBackground"))

                                        Spacer()
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 14)
                                    .background(
                                        RoundedRectangle(cornerRadius: 40, style: .continuous)
                                            .fill(Color("FontBackground"))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 40, style: .continuous)
                                                    .strokeBorder(Color.clear)
                                            )
                                    )
                                }
                                .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
                                .listRowBackground(Color.clear)
                            }
                            .onDelete(perform: viagemVM.deleteTrip)
                           }
                        }
                        .scrollContentBackground(.hidden)
                        .listStyle(.plain)
                    }
                }
            }
        }
    }


#Preview {
    HomeView()
        .environmentObject(ViagemViewModel())
}
