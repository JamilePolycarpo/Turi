import SwiftUI
import UIKit
import Foundation

// MARK: - SwiftUI Pure Version

/// Versão SwiftUI pura - usa modificadores nativos (controle limitado de line spacing)
public struct InknutText: View {
    let text: String
    let font: String
    let size: CGFloat
    let color: Color
    let lineSpacing: CGFloat
    let alignment: TextAlignment
    
    public init(
        _ text: String,
        font: String = "InknutAntiqua-Light",
        size: CGFloat,
        color: Color = .white,
        lineSpacing: CGFloat = -4,
        alignment: TextAlignment = .leading
    ) {
        self.text = text
        self.font = font
        self.size = size
        self.color = color
        self.lineSpacing = lineSpacing
        self.alignment = alignment
    }
    
    public var body: some View {
        Text(text)
            .font(.custom(font, size: size))
            .foregroundColor(color)
            .lineSpacing(lineSpacing)
            .multilineTextAlignment(alignment)
    }
}

// Modificador de tipografia SwiftUI
public struct InknutModifier: ViewModifier {
    let font: String
    let size: CGFloat
    let color: Color?
    let lineSpacing: CGFloat
    
    public func body(content: Content) -> some View {
        content
            .font(.custom(font, size: size))
            .lineSpacing(lineSpacing)
            .modifier(OptionalForegroundStyle(color: color))
    }
}

public extension View {
    func inknut(
        _ font: String = "InknutAntiqua-Light",
        size: CGFloat,
        color: Color? = nil,
        lineSpacing: CGFloat = -4
    ) -> some View {
        self.modifier(InknutModifier(font: font, size: size, color: color, lineSpacing: lineSpacing))
    }
}

// MARK: - UIKit Version (Controle preciso)

// UILabel customizado com controle de line height
public struct CompactText: UIViewRepresentable {
    let text: String
    let font: String
    let fontSize: CGFloat
    let lineHeightMultiple: CGFloat
    let textColor: Color
    let numberOfLines: Int
    let shadowColor: Color?
    let shadowRadius: CGFloat
    let shadowOffset: CGSize
    let alignment: NSTextAlignment
    
    public init(
        text: String,
        font: String = "InknutAntiqua-Light",
        fontSize: CGFloat,
        lineHeightMultiple: CGFloat = 0.75,
        textColor: Color = .white,
        numberOfLines: Int = 0,
        shadowColor: Color? = .black,
        shadowRadius: CGFloat = 2,
        shadowOffset: CGSize = CGSize(width: 1, height: 1),
        alignment: NSTextAlignment = .left
    ) {
        self.text = text
        self.font = font
        self.fontSize = fontSize
        self.lineHeightMultiple = lineHeightMultiple
        self.textColor = textColor
        self.numberOfLines = numberOfLines
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.alignment = alignment
    }
    
    public func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = numberOfLines
        label.lineBreakMode = numberOfLines == 0 ? .byWordWrapping : .byTruncatingTail
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }
    
    public func updateUIView(_ uiView: UILabel, context: Context) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.lineBreakMode = numberOfLines == 0 ? .byWordWrapping : .byTruncatingTail
        paragraphStyle.alignment = alignment
        paragraphStyle.lineSpacing = 0
        paragraphStyle.paragraphSpacing = 0
        paragraphStyle.paragraphSpacingBefore = 0
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: font, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize),
            .foregroundColor: UIColor(textColor),
            .paragraphStyle: paragraphStyle,
            .baselineOffset: 0
        ]
        
        uiView.attributedText = NSAttributedString(string: text, attributes: attributes)
        uiView.numberOfLines = numberOfLines
        uiView.lineBreakMode = numberOfLines == 0 ? .byWordWrapping : .byTruncatingTail
        uiView.textAlignment = alignment
        
        if let shadowColor = shadowColor {
            uiView.layer.shadowColor = UIColor(shadowColor).cgColor
            uiView.layer.shadowRadius = shadowRadius
            uiView.layer.shadowOpacity = 0.5
            uiView.layer.shadowOffset = shadowOffset
        }
    }
}

// MARK: - Legacy Styles (Compatibilidade)
public struct InkAntiquaStyle: ViewModifier {
    public enum Weight: String {
        case light = "InknutAntiqua-Light"
        case regular = "InknutAntiqua-Regular"
        case bold = "InknutAntiqua-Bold"
    }

    private let weight: Weight
    private let size: CGFloat
    private let color: Color?
    private let shadow: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat)?

    public init(weight: Weight, size: CGFloat, color: Color? = nil, shadow: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat)? = nil) {
        self.weight = weight
        self.size = size
        self.color = color
        self.shadow = shadow
    }

    public func body(content: Content) -> some View {
        content
            .font(.custom(weight.rawValue, size: size))
            .modifier(OptionalForegroundStyle(color: color))
            .modifier(OptionalShadow(shadow: shadow))
    }
}

private struct OptionalForegroundStyle: ViewModifier {
    let color: Color?
    func body(content: Content) -> some View {
        if let color { content.foregroundStyle(color) } else { content }
    }
}

private struct OptionalShadow: ViewModifier {
    let shadow: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat)?
    func body(content: Content) -> some View {
        if let s = shadow { content.shadow(color: s.color, radius: s.radius, x: s.x, y: s.y) } else { content }
    }
}

public extension View {
    func inkAntiqua(_ weight: InkAntiquaStyle.Weight, size: CGFloat, color: Color? = nil, shadow: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat)? = nil) -> some View {
        self.modifier(InkAntiquaStyle(weight: weight, size: size, color: color, shadow: shadow))
    }
}

// MARK: - Exemplos de Uso e Documentação

/*
 
 ✨ GUIA DE TIPOGRAFIA TURI ✨
 
 Temos 2 opções de tipografia com diferentes níveis de controle:
 
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 
 1️⃣ SwiftUI PURO (Simples e Nativo) - InknutText
 
    - ✅ Usa modificadores nativos do SwiftUI
    - ✅ Controle de line spacing com valores negativos
    - ✅ Leve e performático
    - ✅ 100% SwiftUI
    - ⚠️ Limitado: não tem controle preciso de lineHeightMultiple
 
    Exemplo como componente:
    ```swift
    InknutText(
        "Sua lista de viagens",
        size: 32,
        color: Color("FontBackground"),
        lineSpacing: -8,  // Valores negativos compactam
        alignment: .leading
    )
    ```
 
    Como modificador (para Text existente):
    ```swift
    Text("Título")
        .inknut(
            font: "InknutAntiqua-Bold",
            size: 28,
            color: .white,
            lineSpacing: -6
        )
    ```
 
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 
 2️⃣ UIKit (Controle Preciso) - CompactText
 
    - ✅ Usa UILabel via UIViewRepresentable
    - ✅ Controle TOTAL de lineHeightMultiple (0.5 a 1.5)
    - ✅ Melhor para textos complexos com múltiplas linhas
    - ✅ Quebra de linha perfeita
    - ✅ Recomendado quando precisa de espaçamento MUITO compacto
    - ⚠️ Usa UIKit (mas funciona perfeitamente no SwiftUI)
 
    Exemplo:
    ```swift
    CompactText(
        text: "Tenha o mundo nas suas mãos",
        fontSize: 32,
        lineHeightMultiple: 0.7,  // 70% do normal = super compacto!
        textColor: Color("FontBackground"),
        numberOfLines: 3,
        shadowColor: nil,
        alignment: .left
    )
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 24)
    ```
 
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 
 📊 COMPARAÇÃO:
 
 | Característica          | InknutText  | CompactText |
 |-------------------------|-------------|-------------|
 | Simplicidade            | ⭐⭐⭐⭐⭐     | ⭐⭐⭐        |
 | Controle Preciso        | ⭐⭐          | ⭐⭐⭐⭐⭐      |
 | Performance             | ⭐⭐⭐⭐⭐     | ⭐⭐⭐⭐       |
 | 100% SwiftUI            | ✅           | ❌          |
 | Controle quebra linha   | ⭐⭐          | ⭐⭐⭐⭐⭐      |
 | Line Height < 0.8       | ❌ limitado  | ✅ perfeito |
 
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 
 💡 QUANDO USAR CADA UMA?
 
 Use InknutText quando:
 ✅ Texto simples de 1-2 linhas
 ✅ Quer algo rápido e nativo SwiftUI
 ✅ lineSpacing de -4 a -10 é suficiente
 ✅ Não precisa de controle super preciso
 
 Use CompactText quando:
 ✅ Precisa de espaçamento MUITO compacto (lineHeightMultiple < 0.8)
 ✅ Texto com múltiplas linhas complexas
 ✅ Controle total e preciso é essencial
 ✅ "Tenha o mundo nas suas mãos" em 2 linhas bem compactas
 
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 
 🎯 REGRA DE OURO:
 
 - Para títulos simples → InknutText
 - Para textos compactos de múltiplas linhas → CompactText
 
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 
 */
