import Foundation
import SwiftUI

public enum IconData: Int, CaseIterable, Codable, Sendable {
    case icnMan1
    case icnMan2
    case icnMan3
    case icnMan4
    case icnMan5
    case icnMan6
    case icnMan7
    case icnMan8
    case icnMan9
    case icnWoman1
    case icnWoman2
    case icnWoman3
    case icnWoman4
    case icnWoman5
    case icnWoman6
    case icnWoman7
    case icnWoman8
    case icnWoman9
    
    public var id: Int {
        self.rawValue
    }
}

extension IconData {
    // Static property to get all templates as array
    public static var allIconDatas: [IconData] {
        IconData.allCases
    }
    
    // Get template by ID
    public static func iconData(withId id: Int) -> IconData? {
        IconData(rawValue: id)
    }
}
