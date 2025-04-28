import Foundation
import PackagePlugin

@main
struct AssetGenPlugin: BuildToolPlugin {
    private let generatedFileName = "AssetGen.swift"
    
    func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
        guard let target = target as? SourceModuleTarget else {
            return []
        }
        
        let generatedFileContent = """
        import Foundation
        import SwiftUI
        
        extension Color {
        \(EscapeCharacter.tab.rawValue)\(fetchAsset(in: target, for: .colorset).map(\.toStaticProperty)
            .joined(separator: "\(EscapeCharacter.newLine.rawValue)\(EscapeCharacter.tab.rawValue)"))
        }
        
        extension Image {
        \(EscapeCharacter.tab.rawValue)\(fetchAsset(in: target, for: .imageset).map(\.toStaticProperty)
            .joined(separator: "\(EscapeCharacter.newLine.rawValue)\(EscapeCharacter.tab.rawValue)"))
        }
        """
        
        
        // TODO: Generate for images
        
        let tmpOutputFilePathString = try tmpOutputFilePath().string
        try generatedFileContent.write(to: URL(fileURLWithPath: tmpOutputFilePathString), atomically: true, encoding: .utf8)
        print("[AssetGen] - Writing to temp file at \(tmpOutputFilePathString)")
        let outputFilePath = try outputFilePath(workDirectory: context.pluginWorkDirectory)
        print("[AssetGen] - For output check \(outputFilePath)")
        
        // TODO: Auto generating take too much build time
        // Find a way to build only when new asset is added.
        return [
            .prebuildCommand(
                displayName: "AssetGenPlugin",
                executable: Path("/bin/cp"),
                arguments: [tmpOutputFilePathString, outputFilePath.string],
                outputFilesDirectory: outputFilePath.removingLastComponent()
            )
        ]
    }
    
    private func fetchAsset(in target: SourceModuleTarget, for ext: FileExtension) -> [Asset] {
        do {
            let result = try target.sourceFiles(withSuffix: FileExtension.xcassets.rawValue).map { catalog in
                // path to the catalog asset
                let input = catalog.path
                // list of assets in the catalog asset  as string
                let assets: [Asset] = try FileManager.default.fetchAssets(using: ext.fetcher, atPath: input.string)
                
                // show debug log
                print("[AssetGen] - Found asset catalog named \(input.stem).\(FileExtension.xcassets.rawValue)")
                print("[AssetGen] - Searching for \(ext.rawValue)...")
                print("[AssetGen] - Found \(assets.count) \(ext.rawValue) in this catalog")
                
                // return all color name in camel case
                return assets
            }
            // flat map [[String]] from multiple catalog to single [String]
            .flatMap { $0 }
            
            return result
        } catch {
            return []
        }
    }
    
    private func tmpOutputFilePath() throws -> Path {
        let tmpDirectory = Path(NSTemporaryDirectory())
        try FileManager.default.createDirectoryIfNotExists(atPath: tmpDirectory.string)
        return tmpDirectory.appending(generatedFileName)
    }
    
    private func outputFilePath(workDirectory: Path) throws -> Path {
        let outputDirectory = workDirectory.appending("Output")
        try FileManager.default.createDirectoryIfNotExists(atPath: outputDirectory.string)
        return outputDirectory.appending(generatedFileName)
    }
}
