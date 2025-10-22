import SwiftUI
import UIKit

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

// Estilo original mantido para compatibilidade
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
