import Foundation
import SwiftUI

public enum ColorTemplate: Int, CaseIterable, Codable, Sendable {
    case redOrange = 0
    case blueCyan = 1
    case greenMint = 2
    case purplePink = 3
    case orangeYellow = 4
    case indigoBlue = 5
    
    public var id: Int {
        self.rawValue
    }
}

extension ColorTemplate {
    // Static property to get all templates as array
    public static var allTemplates: [ColorTemplate] {
        ColorTemplate.allCases
    }
    
    // Get template by ID
    public static func template(withId id: Int) -> ColorTemplate? {
       ColorTemplate(rawValue: id)
    }
}
