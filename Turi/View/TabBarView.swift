import SwiftUI

enum TabItem: Int, CaseIterable {
    case home
    case passagem
    case maps
    case chat
    case settings

    var iconName: String {
        switch self {
        case .home: return "house"
        case .passagem: return "magnifyingglass"
        case .maps: return "mappin"
        case .chat: return "bubble.left"
        case .settings: return "gearshape"
        }
    }

    var iconNameFill: String {
        switch self {
        case .home: return "house.fill"
        case .passagem: return "magnifyingglass"
        case .maps: return "mappin.fill"
        case .chat: return "bubble.left.fill"
        case .settings: return "gearshape.fill"
        }
    }

    var title: String {
        switch self {
        case .home: return "Home"
        case .passagem: return "Buscar"
        case .maps: return "Mapas"
        case .chat: return "Chat"
        case .settings: return "Config"
        }
    }
}

@available(iOS 17.0, *)
struct TabBarView: View {
    @State private var selectedTab: TabItem = .home
    @StateObject private var viagem = ViagemViewModel()
    @State private var hideTabBar = false

   
    var body: some View {
        GeometryReader { geo in
            let safeBottom = geo.safeAreaInsets.bottom
            ZStack(alignment: .bottom) {
                Group {
                    switch selectedTab {
                    case .home:
                        if #available(iOS 17.0, *) {
                            NavigationStack { HomeView(hideTabBar: $hideTabBar) }
                        } else {
                            NavigationView { HomeView(hideTabBar: $hideTabBar) }
                        }
                    case .passagem:
                        if #available(iOS 17.0, *) {
                            NavigationStack { PassagemView() }
                        } else {
                            NavigationView { PassagemView() }
                        }
                    case .maps:
                        if #available(iOS 17.0, *) {
                            NavigationStack { MapsView() }
                        } else {
                            NavigationView { MapsView() }
                        }
                    case .chat:
                        if #available(iOS 17.0, *) {
                            NavigationStack { ChatView() }
                        } else {
                            NavigationView { ChatView() }
                        }
                    case .settings:
                        if #available(iOS 17.0, *) {
                            NavigationStack { SettingsView() }
                        } else {
                            NavigationView { SettingsView() }
                        }
                    }
                }
                .environmentObject(viagem)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                if !hideTabBar {
                    CustomTabBar(selectedTab: $selectedTab)
                        .frame(height: max(geo.size.height * 0.11, 90))
                        .padding(.horizontal, max(geo.size.width * 0.06, 24))
                        .padding(.bottom, safeBottom > 0 ? safeBottom : max(geo.size.height * 0.012, 10))
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem

    var body: some View {
        GeometryReader{ geo in
            HStack {
                ForEach(TabItem.allCases, id: \.self) { item in
                    let isSelected = selectedTab == item
                    
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            selectedTab = item
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: isSelected ? item.iconNameFill : item.iconName)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(isSelected ? Color("FontBackground") : Color("ColorBackground"))
                                .scaleEffect(isSelected ? 1.2 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isSelected)
                            
                        }
                       
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(isSelected ? Color("ColorBackground") : Color.clear)
                                .frame(width: geo.size.width * 0.14, height: geo.size.height * 0.45)
                                .animation(.easeInOut(duration: 0.25), value: isSelected)
                        )
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 40, style: .continuous)
                    .fill(Color("FontBackground"))
                    .frame(height: geo.size.height * 0.65)
                   
                    .shadow(color: Color("ColorBackground"), radius: 50, x: 0, y: 3)
            ) .frame(height: geo.size.height * 1.8)
        }
    }
}

#Preview {
    if #available(iOS 17.0, *) {
        TabBarView()
    } else {
        // Fallback on earlier versions
    }
}
