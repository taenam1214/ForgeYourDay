import SwiftUI

// MARK: - Color Palette
extension Color {
    static let primaryDark = Color(hex: "#1C1C1C")
    static let primaryLight = Color(hex: "#F5E6D0")
    static let accent = Color(hex: "#E07A5F")
    static let secondary = Color(hex: "#3D405B")
}

// MARK: - Font Styles
extension Font {
    // Make sure to add Manrope and Inter font files to your project and Info.plist
    static func manrope(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        Font.custom("Manrope", size: size).weight(weight)
    }
    static func inter(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        Font.custom("Inter", size: size).weight(weight)
    }
    // Example font styles
    static var title: Font { manrope(size: 28, weight: .bold) }
    static var body: Font { inter(size: 17) }
    static var caption: Font { inter(size: 13) }
}

// MARK: - Spacing & Corner Radius
struct Theme {
    static let cornerRadius: CGFloat = 12
    static let padding: CGFloat = 16
    static let smallPadding: CGFloat = 8
}

// MARK: - Color Hex Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// Usage Example (in your views):
// .font(.title)
// .foregroundColor(.primaryDark)
// .padding(Theme.padding) 