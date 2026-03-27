import SwiftUI

extension Color {
    static let appRed   = Color(red: 220/255, green:  50/255, blue:  50/255)

    static let appGray6 = Color(red: 242/255, green: 242/255, blue: 247/255)
    static let appGray5 = Color(red: 229/255, green: 229/255, blue: 234/255)
    static let appGray4 = Color(red: 209/255, green: 209/255, blue: 214/255)
    static let appGray3 = Color(red: 199/255, green: 199/255, blue: 204/255)
    static let appGray2 = Color(red: 174/255, green: 174/255, blue: 178/255)
    static let appGray  = Color(red: 142/255, green: 142/255, blue: 147/255)
}

extension Font {
    static func sfPro(_ size: CGFloat) -> Font {
        .custom("SF Pro Display", size: size)
    }
}
