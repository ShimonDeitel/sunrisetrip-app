import SwiftUI

/// Unique visual identity for Sunrise Tracker.
enum Theme {
    static let accent = Color(red: 0.910, green: 0.416, blue: 0.200)
    static let background = Color(red: 0.106, green: 0.055, blue: 0.024)
    static let cardBackground = Color(red: 0.166, green: 0.115, blue: 0.084)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.65)

    static let titleFont = Font.system(.title2, design: .rounded).weight(.bold)
    static let headlineFont = Font.system(.headline, design: .rounded)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.caption, design: .rounded)

    static let cornerRadius: CGFloat = 16
}
