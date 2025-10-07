internal import SwiftUI

enum TabItem: Int, CaseIterable {
    case home = 0, passagem, maps, chat, settings

    var iconName: String {
        switch self {
        case .home:      return "house"
        case .passagem:  return "ticket"
        case .maps:      return "map"
        case .chat:      return "bubble.left.and.bubble.right"
        case .settings:  return "person"
        }
    }

    var iconNameFill: String {
        switch self {
        case .home:      return "house.fill"
        case .passagem:  return "ticket.fill"
        case .maps:      return "map.fill"
        case .chat:      return "bubble.left.and.bubble.right.fill"
        case .settings:  return "person.fill"
        }
    }
}

struct TabBarView: View {
    @State private var selectedTab: TabItem = .home
    @Namespace private var tabNS
    @StateObject private var viagem = ViagemViewModel()

    var body: some View {
        GeometryReader { geo in
            let safeBottom = geo.safeAreaInsets.bottom
            let tabHeight = geo.size.height * 0.09

            ZStack(alignment: .bottom) {
                // Conteúdo principal das abas
                TabView(selection: $selectedTab) {
                    HomeView().tag(TabItem.home)
                    PassagemView().tag(TabItem.passagem)
                    MapsView().tag(TabItem.maps)
                    ChatView().tag(TabItem.chat)
                    SettingsView().tag(TabItem.settings)
                }
                .environmentObject(viagem)
                .onAppear { UITabBar.appearance().isHidden = true }
                .toolbar(.hidden, for: .tabBar)

                // Tab bar customizada com blur e imagem de fundo
                CustomTabBar(selectedTab: $selectedTab, ns: tabNS)
                    .frame(height: tabHeight)
                    .padding(.bottom, safeBottom > 0 ? safeBottom : 10)
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    var ns: Namespace.ID
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let spacing = width < 400 ? 10.0 : 16.0

            ZStack {
                RoundedRectangle(cornerRadius:0, style: .continuous)
                                .fill(Color(.clear))
                                .frame(maxWidth: .infinity, maxHeight: 130)
                                .background(
                                    ZStack {
                                        Color("ColorBackground")
                                            .ignoresSafeArea(edges: .all)
                                        Image("background")
                                            .resizable()
                                            .scaledToFill()
                                            .ignoresSafeArea(edges: .all)
                                    }
                                )
                                .ignoresSafeArea(edges: .all)
                                .clipped()
                                .blur(radius: 10)

                // 🔹 Ícones das abas
                HStack(spacing: spacing) {
                    ForEach(TabItem.allCases, id: \.self) { item in
                        let isSelected = selectedTab == item

                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                                selectedTab = item
                            }
                        } label: {
                            Image(systemName: isSelected ? item.iconNameFill : item.iconName)
                                .font(.system(size: width < 400 ? 18 : 22, weight: .semibold))
                                .foregroundColor(isSelected ? Color("FontBackground") : Color("ColorBackground"))
                                .scaleEffect(isSelected ? 1.15 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isSelected)
                                .padding(.vertical, 12)
                                .padding(.horizontal, isSelected ? 22 : 14)
                                .background(
                                    Group {
                                        if isSelected {
                                            Capsule()
                                                .fill(Color("ColorBackground"))
                                                .matchedGeometryEffect(id: "TAB_BG", in: ns)
                                        }
                                    }
                                )
                        }
                        .buttonStyle(.plain)
                        
                    }
                }
                .padding(.horizontal, spacing)
                .padding(.vertical, 10)
                .background(Color("FontBackground").opacity(0.95))
                .clipShape(RoundedRectangle(cornerRadius: 50, style: .continuous))
                .shadow(color: Color("ColorBackground").opacity(0.35), radius: 12, x: 0, y: 4)
                .padding(.horizontal, 16)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

#Preview {
    TabBarView()
}
