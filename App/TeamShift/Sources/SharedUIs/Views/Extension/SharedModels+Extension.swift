import SharedModels
import SwiftUI

extension IconData {
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

extension ColorTemplate {
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
