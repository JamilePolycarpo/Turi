//
//  HomeView.swift
//  Turi
//
//  Created by Jamile Marian Polycarpo on 03/10/25.
//
import SwiftUI
import Combine
import Foundation

@available(iOS 17.0, *)
private struct CarouselSlide: View {
    let imageName: String
    let title: String
    let description: String
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: height)
                .clipped()
            Rectangle()
                .fill(Color.black.opacity(0.3))
                .frame(height: height)

            VStack(alignment: .leading, spacing: 8) {
                CompactText(
                    text: title,
                    fontSize: 32,
                    lineHeightMultiple: 0.75,
                    numberOfLines: 0
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                
                CompactText(
                    text: description,
                    fontSize: 16,
                    lineHeightMultiple: 0.6,
                    numberOfLines: 2
                )
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.leading, 20)
            .padding(.bottom, 20)
            .padding(.trailing, 20)
        }
        .frame(width: width, height: height)
        .clipped()
    }
}

@available(iOS 17.0, *)
private struct TripRow: View {
    let name: String
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        HStack(spacing: width * 0.03) {
            ZStack {
                Circle()
                    .fill(Color("ColorBackground").opacity(0.12))
                Image(systemName: "airplane")
                    .foregroundStyle(Color("ColorBackground"))
                    .font(.system(size: min(width * 0.045, 18), weight: .semibold))
            }
            .frame(width: min(width * 0.09, 36), height: min(width * 0.09, 36))
            Text(name)
                .font(.custom("InknutAntiqua-Light", size: min(width * 0.08, 16)))
                .foregroundStyle(Color("ColorBackground"))
            Spacer()
        }
        .padding(.horizontal, width * 0.04)
        .padding(.vertical, height * 0.018)
        .background(
            RoundedRectangle(cornerRadius: width * 0.1, style: .continuous)
                .fill(Color("FontBackground"))
        )
    }
}

@available(iOS 15.0, *)
private struct TypographyText: View {
    let text: String
    let fontSize: CGFloat
    let lineHeightMultiple: CGFloat
    let numberOfLines: Int
    var customFontName: String? = nil

    var body: some View {
        Text(attributed)
            .lineLimit(numberOfLines)
            .multilineTextAlignment(.leading)
    }

    private var attributed: AttributedString {
        // Build via NSAttributedString for widest SDK compatibility (iOS 15+)
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineHeightMultiple = lineHeightMultiple
        paragraph.alignment = .left

        let font: UIFont
        if let customFontName, let custom = UIFont(name: customFontName, size: fontSize) {
            font = custom
        } else {
            font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        }

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraph
        ]

        let nsAttr = NSAttributedString(string: text, attributes: attributes)
        return AttributedString(nsAttr)
    }
}

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
                let width = geo.size.width
                let height = geo.size.height
                let carouselHeight = height * 0.35
                
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
                                CarouselSlide(
                                    imageName: imageName,
                                    title: carouselTitles[index],
                                    description: carouselDescriptions[index],
                                    width: width,
                                    height: carouselHeight
                                )
                                .tag(index)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .automatic))
                        .frame(width: width, height: carouselHeight)
                        .clipped()
                        .ignoresSafeArea(.container, edges: .top)
                        .id(currentIndex)

                        HStack {
                            CompactText(text: "Sua lista de viagem ", fontSize: 32, lineHeightMultiple: 0.7, numberOfLines: 2)
                            .fixedSize(horizontal: false, vertical: true)
                             
                             Spacer()
                             
                            NavigationLink(destination: AddViagemView(hideTabBar: $hideTabBar)) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: min(width * 0.1, 40)))
                                    .foregroundColor(Color("FontBackground"))
                            }
                        }
                        .padding(.vertical, height * 0.01)
                        .padding(.horizontal, max(width * 0.05, 20))

                        List {
                            ForEach($viagemVM.trips, id: \.id) { $trip in
                                NavigationLink(destination: DetalheViagemView(trip: $trip, hideTabBar: $hideTabBar)) {
                                    TripRow(name: trip.nome, width: width, height: height)
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
