import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct DictionaryBuilder: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // Ensure the macro is attached to a struct
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            let diag = Diagnostic(node: Syntax(node), message: MacroError.notApplicableToNonStructs)
            context.diagnose(diag)
            return []
        }
        
        var updaterMethods: [String] = []
        let builderStructName = "DictionaryBuilder"
        let builderFactoryMethodName = "dictionaryBuilder"
        
        // Iterate over the members of the struct to find stored properties
        for member in structDecl.memberBlock.members {
            // get variable declarations
            guard let varDecl = member.decl.as(VariableDeclSyntax.self) else {
                continue
            }
            
            // Iterate over each binding in the variable declaration (e.g., var x: Int, y: String)
            for binding in varDecl.bindings {
                guard let propertyNameToken = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier,
                      let propertyTypeSyntax = binding.typeAnnotation?.type else {
                    continue
                }
                
                let propertyName = propertyNameToken.text
                let propertyType = propertyTypeSyntax.trimmedDescription
                // Use backticks for safety
                let methodName = "`\(propertyName)`"

                updaterMethods.append(
                    """
                        public func \(methodName)(_ value: \(propertyType)) -> Self {
                            var newSelf = self
                            // Get the coding keys
                            let codingKey = CodingKeys.\(propertyName).stringValue
                    
                            // Check if value is RawRepresentable and use rawValue if possible
                            if let rawRepresentable = value as? any RawRepresentable {
                                newSelf._updates[codingKey] = rawRepresentable.rawValue
                            } else {
                                newSelf._updates[codingKey] = value
                            }
                    
                            return newSelf
                        }
                    """
                )
            }
        }
        
        // Define the nested UpdateBuilder struct
        let updateBuilderStructDeclString =
            """
            public struct \(builderStructName) {
                fileprivate var _updates: [String: Any] = [:]
            
                fileprivate init() {}
            
                \(updaterMethods.joined(separator: "\n        "))
            
                public var dictionary: [String: Any] {
                    return _updates
                }
            
                public func buildDict() -> [String: Any] {
                    return _updates
                }
            }
            """
        
        // Define the method to be added to the parent struct
        let updateBuilderFactoryMethodDeclString =
            """
            public func \(builderFactoryMethodName)() -> \(builderStructName) {
                return \(builderStructName)()
            }
            """
        
        return [
            DeclSyntax(stringLiteral: updateBuilderStructDeclString),
            DeclSyntax(stringLiteral: updateBuilderFactoryMethodDeclString)
        ]
    }
}
