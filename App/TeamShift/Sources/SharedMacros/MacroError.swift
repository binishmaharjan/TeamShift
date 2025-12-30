import Foundation
import SwiftDiagnostics

public struct MacroError: Error, DiagnosticMessage {
    public static let notApplicableToNonStructs = Self(
        message: "@UpdateBuilder can only be applied to structs.",
        diagnosticID: MessageID(domain: "MyMacros", id: "notApplicableToNonStructs"), 
        severity: .error
    )
    
    public var message: String
    public var diagnosticID: MessageID
    public var severity: DiagnosticSeverity
}
