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
    
    public var image: Image {
        switch self {
        case .icnMan1:
            return Image.icnMan1
            
        case .icnMan2:
            return Image.icnMan2
            
        case .icnMan3:
            return Image.icnMan3
            
        case .icnMan4:
            return Image.icnMan4
            
        case .icnMan5:
            return Image.icnMan5
            
        case .icnMan6:
            return Image.icnMan6
            
        case .icnMan7:
            return Image.icnMan7
            
        case .icnMan8:
            return Image.icnMan8
            
        case .icnMan9:
            return Image.icnMan9
            
        case .icnWoman1:
            return Image.icnWoman1
            
        case .icnWoman2:
            return Image.icnWoman2
            
        case .icnWoman3:
            return Image.icnWoman3
            
        case .icnWoman4:
            return Image.icnWoman4
            
        case .icnWoman5:
            return Image.icnWoman5
            
        case .icnWoman6:
            return Image.icnWoman6
            
        case .icnWoman7:
            return Image.icnWoman7
            
        case .icnWoman8:
            return Image.icnWoman8
            
        case .icnWoman9:
            return Image.icnWoman9
        }
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
