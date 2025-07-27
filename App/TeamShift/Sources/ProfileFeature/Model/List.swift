import UserSessionClient
import Dependencies
import Foundation
import SharedUIs
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
        switch self {
        case .account:
            return l10.profileSectionAccount
            
        case .preference:
            return l10.profileSectionPreference
            
        case .other:
            return l10.profileSectionOthers
        }
    }
    
    @MainActor
    var rows: [ProfileRow] {
        @Dependency(\.userSession) var userSession
        
        switch self {
        case .account:
            var rows: [ProfileRow] = [.changeAvatar, .changeUsername]
            if userSession.isSignInMethod(.email) {
                rows.append(.changePassword)
            }
            
            if userSession.isSignInMethod(.guest) {
                rows.append(.linkAccount)
            }
            
            rows.append(.deleteAccount)
            
            return rows
            
        case .preference:
            return [.startWeekDay, .showPublicHoliday]
            
        case .other:
            return [.license]
        }
    }
}

enum ProfileRow: String {
    case changeAvatar
    case changeUsername
    case changePassword
    case linkAccount
    case deleteAccount
    // case goPro
    
    case startWeekDay
    case showPublicHoliday
    // case notification
    
    case license
    
    var title: String {
        switch self {
        case .changeAvatar:
            return l10.profileRowChangeAvatar
            
        case .changeUsername:
            return l10.profileRowChangeUsername
            
        case .changePassword:
            return l10.profileRowChangePassword
            
        case .linkAccount:
            return l10.profileRowLinkAcccount
            
        case .deleteAccount:
            return l10.profileRowDeleteAccount
            
        case .startWeekDay:
            return l10.profileRowStartWeekDay
            
        case .showPublicHoliday:
            return l10.profileRowShowPublicHoliday
            
        case .license:
            return l10.profileRowLicense
        }
    }
    
    var image: Image {
        switch self {
        case .changeAvatar:
            return .icnEditPerson
            
        case .changeUsername:
            return .icnEditNote
            
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
        case .changeAvatar, .changeUsername, .changePassword, .linkAccount, .deleteAccount, .startWeekDay, .license:
            return .navigation
            
        case .showPublicHoliday:
            return .toggle
        }
    }
}
