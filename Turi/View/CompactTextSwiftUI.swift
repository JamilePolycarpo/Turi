import SwiftUI

public struct CompactTextSwiftUI: View {
    public let text: String
    public let fontName: String
    public let fontSize: CGFloat
    public let lineHeightMultiple: CGFloat
    public let textColor: Color
    public let numberOfLines: Int
    public let alignment: TextAlignment
    public let shadowColor: Color?
    public let shadowRadius: CGFloat
    public let shadowOffset: CGSize

    public init(
        text: String,
        fontName: String = "InknutAntiqua-Light",
        fontSize: CGFloat,
        lineHeightMultiple: CGFloat = 0.75,
        textColor: Color = .white,
        numberOfLines: Int = 0,
        alignment: TextAlignment = .leading,
        shadowColor: Color? = .black,
        shadowRadius: CGFloat = 2,
        shadowOffset: CGSize = CGSize(width: 1, height: 1)
    ) {
        self.text = text
        self.fontName = fontName
        self.fontSize = fontSize
        self.lineHeightMultiple = lineHeightMultiple
        self.textColor = textColor
        self.numberOfLines = numberOfLines
        self.alignment = alignment
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
    }

    public var body: some View {
        // Approximate line height multiple using lineSpacing relative to font size.
        // SwiftUI doesn't expose a direct lineHeightMultiple, so we compute a spacing delta.
        let spacing = (lineHeightMultiple - 1.0) * fontSize

        let base = Text(text)
            .font(.custom(fontName, size: fontSize))
            .foregroundStyle(textColor)
            .multilineTextAlignment(alignment)
            .lineLimit(numberOfLines == 0 ? nil : numberOfLines)
            .lineSpacing(spacing)

        if let shadowColor {
            base
                .shadow(color: shadowColor.opacity(0.5), radius: shadowRadius, x: shadowOffset.width, y: shadowOffset.height)
        } else {
            base
        }
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 16) {
        CompactTextSwiftUI(text: "Título de Exemplo\nEm Duas Linhas", fontSize: 28, lineHeightMultiple: 0.8, textColor: .white, numberOfLines: 0, alignment: .center)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .background(Color.blue)
        CompactTextSwiftUI(text: "Texto corrido com múltiplas linhas para verificar o espaçamento aproximado.", fontSize: 16, lineHeightMultiple: 1.1, textColor: .black, numberOfLines: 3, alignment: .leading, shadowColor: nil)
            .padding()
            .background(Color.gray.opacity(0.2))
    }
    .padding()
}
#endif

