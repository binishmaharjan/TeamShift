import Foundation
import SharedUIs
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
    
    public var gradient: LinearGradient {
        switch self {
        case .redOrange:
            return LinearGradient(
                colors: [Color.red.opacity(0.6), Color.orange.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
        case .blueCyan:
            return LinearGradient(
                colors: [Color.blue.opacity(0.6), Color.cyan.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
        case .greenMint:
            return LinearGradient(
                colors: [Color.green.opacity(0.6), Color.mint.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
        case .purplePink:
            return LinearGradient(
                colors: [Color.purple.opacity(0.6), Color.pink.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
        case .orangeYellow:
            return LinearGradient(
                colors: [Color.orange.opacity(0.6), Color.yellow.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
        case .indigoBlue:
            return LinearGradient(
                colors: [Color.indigo.opacity(0.6), Color.blue.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
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
