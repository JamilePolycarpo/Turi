//
//  ChatView.swift
//  Turi
//
//  Created by Jamile Marian Polycarpo on 03/10/25.
//

import SwiftUI

// MARK: - Design tokens
private enum TuriColors {
    static let cream = Color(hex: "#F1F2DF")
    static let deepGreen = Color(hex: "#0C6A57")
    static let teal = Color(hex: "#2E8A73")
    static let bubbleDark = Color(hex: "#0A4D41")
    static let bubbleLight = Color(hex: "#D9E2CC")
    static let bubbleDarkStroke = Color.white.opacity(0.12)
    static let placeholder = Color.white.opacity(0.5)
    static let tabIcon = Color(hex: "#0D6C58")
}

// MARK: - Screen
struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @FocusState private var isInputFocused: Bool

    var body: some View {
        ZStack {
            // Fundo com textura/gradiente
            Color("ColorBackground")
                .ignoresSafeArea(edges: .all)
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(edges: .all)

            VStack(spacing: 0) {
                HeaderView()
                
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(viewModel.messages) { message in
                                if message.sender == .typing {
                                    TypingIndicatorBubble()
                                        .id(message.id)
                                } else {
                                    ChatBubble(message: message)
                                        .id(message.id)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 8)
                    }
                    .onChange(of: viewModel.messages.count) { _ in
                        // Scroll para a última mensagem
                        if let lastMessage = viewModel.messages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }

                // Mensagem de erro
                if viewModel.showError, let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 8)
                }

                InputBar(text: $viewModel.inputText, onSend: {
                    viewModel.sendMessage()
                })
                .focused($isInputFocused)
                .padding(.horizontal, 16)
                .padding(.bottom, 80)
                .background(Color.clear)
            }
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
}

// MARK: - Header
private struct HeaderView: View {
    var body: some View {
        ZStack(alignment: .leading) {
            TuriColors.cream
                .clipShape(RoundedCorner(radius: 24, corners: [.bottomLeft, .bottomRight]))
                .shadow(color: .black.opacity(0.05), radius: 8, y: 4)

            HStack(spacing: 12) {
                ZStack {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundStyle(TuriColors.tabIcon)
                        .opacity(0.7)
                }
                Text("Chat do Turi")
                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                    .foregroundStyle(TuriColors.tabIcon)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, -30)
        }
        .frame(height: 130)
    }
}

// MARK: - Bubbles

private struct BubbleCapsuleCut: Shape {
    var isUser: Bool
    func path(in rect: CGRect) -> Path {
        // radius like a capsule (half height) but capped
        let r = min(rect.height / 2, 20)
        // Round all corners except the bottom corner on the message side
        var corners: UIRectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight]
        if isUser {
            corners.remove(.bottomRight) // bottom-right squared for user's bubble
        } else {
            corners.remove(.bottomLeft)  // bottom-left squared for bot's bubble
        }
        let bez = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: r, height: r)
        )
        return Path(bez.cgPath)
    }
}

private struct ChatBubble: View {
    let message: ChatMessage

    var isUser: Bool { message.sender == .user }

    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            if isUser { Spacer(minLength: 10) }

            Text(message.text)
                .font(.system(size: 12.5, weight: .regular))
                .foregroundStyle(isUser ? Color.white.opacity(0.92) : Color.black.opacity(0.85))
                .multilineTextAlignment(.leading)
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
                .background(
                    BubbleCapsuleCut(isUser: isUser)
                        .fill(isUser ? TuriColors.bubbleDark : TuriColors.bubbleLight)
                )
                .overlay(
                    BubbleCapsuleCut(isUser: isUser)
                        .stroke(isUser ? TuriColors.bubbleDarkStroke : Color.black.opacity(0.06), lineWidth: 1)
                )

            if !isUser { Spacer(minLength: 56) }
        }
        .frame(maxWidth: .infinity, alignment: isUser ? .trailing : .leading)
    }
}

private struct TypingIndicatorBubble: View {
    var body: some View {
        HStack(alignment: .bottom) {
            HStack(spacing: 6) {
                Circle().fill(Color.black.opacity(0.35)).frame(width: 6, height: 6)
                Circle().fill(Color.black.opacity(0.35)).frame(width: 6, height: 6)
                Circle().fill(Color.black.opacity(0.35)).frame(width: 6, height: 6)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .background(
                BubbleCapsuleCut(isUser: false)
                    .fill(TuriColors.bubbleLight)
            )
            .overlay(
                BubbleCapsuleCut(isUser: false)
                    .stroke(Color.black.opacity(0.06), lineWidth: 1)
            )
            Spacer()
        }
        .padding(.leading, 4)
    }
}

// MARK: - Input
private struct InputBar: View {
    @Binding var text: String
    let onSend: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("digitar")
                    .foregroundStyle(TuriColors.placeholder)
                    .opacity(text.isEmpty ? 1 : 0)
                    .padding(.leading, 20)
                    .allowsHitTesting(false)

                TextField("", text: $text)
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 20)
                    .opacity(text.isEmpty ? 0.001 : 1)
                    .padding()
                    .onSubmit {
                        if !text.isEmpty {
                            onSend()
                        }
                    }
                
                // Botão de enviar
                Button(action: onSend) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(text.isEmpty ? Color.white.opacity(0.3) : Color.white)
                }
                .disabled(text.isEmpty)
                .padding(.trailing, 8)
            }
            .frame(height: 46)
            .frame(maxWidth: .infinity)
            .background(
                Capsule(style: .continuous)
                    .strokeBorder(Color.white.opacity(0.6), lineWidth: 1)
                    .background(
                        Capsule().fill(Color.white.opacity(0.06))
                    )
            )
        }.padding(.bottom, 50)
    }
}

// MARK: - Helpers
private struct RoundedCorner: Shape {
    var radius: CGFloat = 16.0
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

private extension Color {
    init(hex: String) {
        var hexString = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hexString.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 150, 136) // fallback
        }
        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue: Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}

// MARK: - Preview
struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChatView()
                .previewDisplayName("Chat do Turi")
        }
    }
}
