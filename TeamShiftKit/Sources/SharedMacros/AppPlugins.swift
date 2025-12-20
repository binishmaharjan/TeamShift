import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct AppPlugins: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        DictionaryBuilder.self
    ]
}
