import Foundation
import SwiftUI

public enum CustomFont: String, CaseIterable {
    case light = "Roboto-Light"
    case regular = "Roboto-Regular"
    case semiBold = "Roboto-SemiBold"
    case bold = "Roboto-Bold"
}

// MARK: Custom Font Manager
public struct CustomFontManager {
    public static func registerFonts() {
        CustomFont.allCases.forEach {
            registerFont(bundle: .module, fontName: $0.rawValue, fontExtension: "ttf")
        }
    }
    
    fileprivate static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        guard
            let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
            let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
            let font = CGFont(fontDataProvider)
        else {
            fatalError("Couldn't create font from data")
        }
        
        var error: Unmanaged<CFError>?
        
        CTFontManagerRegisterGraphicsFont(font, &error)
    }
}

// MARK: Custom Font Size
extension Font.TextStyle {
    public var size: CGFloat {
        switch self {
        case .largeTitle:
            return 34.0

        case .title:
            return 28.0

        case .title2:
            return 22.0

        case .title3:
            return 20.0

        case .headline:
            return 17.0

        case .subheadline:
            return 15.0

        case .body:
            return 17.0

        case .callout:
            return 16.0

        case .footnote:
            return 13.0

        case .caption:
            return 12.0

        case .caption2:
            return 11.0

        @unknown default:
            return 8.0
        }
    }
}

extension Font {
    /// FontSize: 34.0, Weight: Bold
    public static let customLargeTitle = custom(.bold, relativeTo: .largeTitle)
    /// FontSize: 28.0, Weight: SemiBold
    public static let customTitle = custom(.bold, relativeTo: .title)
    /// FontSize: 22.0, Weight: SemiBold
    public static let customTitle2 = custom(.semiBold, relativeTo: .title2)
    /// FontSize: 20.0, Weight: SemiBold
    public static let customTitle3 = custom(.semiBold, relativeTo: .title3)
    /// FontSize: 17.0, Weight: SemiBold
    public static let customHeadline = custom(.bold, relativeTo: .headline)
    /// FontSize: 17.0, Weight: Regular
    public static let customBody = custom(.regular, relativeTo: .body)
    /// FontSize: 16.0, Weight: Light
    public static let customCallout = custom(.light, relativeTo: .callout)
    /// FontSize: 15.0, Weight: Regular
    public static let customSubHeadline = custom(.semiBold, relativeTo: .subheadline)
    /// FontSize: 13.0, Weight: Light
    public static let customFootnote = custom(.light, relativeTo: .footnote)
    /// FontSize: 12.0, Weight: Regular
    public static let customCaption = custom(.regular, relativeTo: .caption)
    /// FontSize: 11.0, Weight: Light
    public static let customCaption2 = custom(.light, relativeTo: .caption2)
    
    private static func custom(_ font: CustomFont, relativeTo style: Font.TextStyle) -> Font {
        custom(font.rawValue, size: style.size, relativeTo: style)
    }
}
