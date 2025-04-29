import Foundation

protocol Asset {
    var originalName: String { get }
    var camelCaseName: String { get }
    var toStaticProperty: String { get }
}

/// Representation of color asset
struct ColorAsset: Asset {
    var originalName: String
    var camelCaseName: String
    
    var toStaticProperty: String {
        """
        public static let \(camelCaseName) = Color(\"\(originalName)\", bundle: .module)
        """
    }
}

/// Representation of image asset
struct ImageAsset: Asset {
    var originalName: String
    var camelCaseName: String
    
    var toStaticProperty: String {
        """
        public static let \(camelCaseName) = Image(\"\(originalName)\", bundle: .module)
        """
    }
}

/// Representation of string asset
struct StringAsset: Asset {
    var originalName: String
    var camelCaseName: String
    
    var toStaticProperty: String {
        """
        public static let \(camelCaseName) = String(localized: \"\(originalName)\", bundle: .module)
        """
    }
}
