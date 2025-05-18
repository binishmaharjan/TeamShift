import Foundation
import SwiftUI

enum ProfileRowType {
    case navigation
    case toggle
}

enum ProfileSection: String, CaseIterable {
    case account
    case preference
    case other
    
    var title: String {
        rawValue.capitalized
    }
    
    var rows: [ProfileRow] {
        switch self {
        case .account:
            return [.changePassword, .linkAccount, .deleteAccount]
            
        case .preference:
            return [.startWeekDay, .showPublicHoliday]
            
        case .other:
            return [.license]
        }
    }
}

enum ProfileRow: String {
    case changePassword = "Change Password"
    case linkAccount = "Link Account"
    case deleteAccount = "Delete Account"
    
    case startWeekDay = "Start Week Day"
    case showPublicHoliday = "Show Public Holiday"
    
    case license = "License"
    
    var title: String {
        rawValue
    }
    
    var image: Image {
        switch self {
        case .changePassword:
            return .icnWaterLock
            
        case .linkAccount:
            return .icnLink
            
        case .deleteAccount:
            return .icnDeleteUser
            
        case .startWeekDay:
            return .icnEvent
            
        case .showPublicHoliday:
            return .icnGlobe
            
        case .license:
            return .icnDescription
        }
    }
    
    var rowType: ProfileRowType {
        switch self {
        case .changePassword, .linkAccount, .deleteAccount, .startWeekDay, .license:
            return .navigation
            
        case .showPublicHoliday:
            return .toggle
        }
    }
}
