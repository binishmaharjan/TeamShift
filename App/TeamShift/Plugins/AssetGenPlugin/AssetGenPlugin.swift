import Foundation
import PackagePlugin

@main
struct AssetGenPlugin: BuildToolPlugin {
    private let generatedFileName = "AssetGen.swift"
    
    func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
        guard let target = target as? SourceModuleTarget else {
            return []
        }
        
        let strings = fetchLocalizedStrings(in: target)
        let (images, colors) = fetchImagesAndColors(in: target)

        let generatedFileContent = """
        import Foundation
        import SwiftUI
        
        extension Color {
        \(EscapeCharacter.tab.rawValue)\(colors.map(\.toStaticProperty)
            .joined(separator: "\(EscapeCharacter.newLine.rawValue)\(EscapeCharacter.tab.rawValue)"))
        }
        
        extension Image {
        \(EscapeCharacter.tab.rawValue)\(images.map(\.toStaticProperty)
            .joined(separator: "\(EscapeCharacter.newLine.rawValue)\(EscapeCharacter.tab.rawValue)"))
        }
        
        public struct l10 {
        \(EscapeCharacter.tab.rawValue)\(strings.map(\.toStaticProperty)
            .joined(separator: "\(EscapeCharacter.newLine.rawValue)\(EscapeCharacter.tab.rawValue)"))
        }
        """
        
        let tmpOutputFilePathString = try tmpOutputFilePath().string
        try generatedFileContent.write(to: URL(fileURLWithPath: tmpOutputFilePathString), atomically: true, encoding: .utf8)
        print("[AssetGen]:✅: Writing to temp file at \(tmpOutputFilePathString)")
        let outputFilePath = try outputFilePath(workDirectory: context.pluginWorkDirectory)
        print("[AssetGen]:✅: For output check \(outputFilePath)")
        
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
    
    private func fetchLocalizedStrings(in target: SourceModuleTarget) -> [StringAsset] {
        guard let localizedFilePath = target.sourceFiles(withSuffix: ResourceExtension.xcstrings.rawValue).first else {
            return []
        }
        do {
            let assets = try FileManager.default.fetchAssets(using: LocalizableAssetFetcher(), atPath: localizedFilePath.url.absoluteString)
            print("[AssetGen]:✅: Found total of \(assets.count) strings in Localizable.xcstrings")
            return assets
        } catch {
            print("[AssetGen]:❌:  Couldn't find Localizable.xcstrings")
            return []
        }
    }
    
    private func fetchImagesAndColors(in target: SourceModuleTarget) -> ([ImageAsset], [ColorAsset]) {
        do {
            let assetCatalogs: FileList = target.sourceFiles(withSuffix: ResourceExtension.xcassets.rawValue)
            
            // 1. Map each asset catalog path to a tuple of its image and color assets.
            let assetsPerCatalog: [([ImageAsset], [ColorAsset])] = try assetCatalogs.map { catalog in
                let input = catalog.path
                let inputString = input.string
                print("[AssetGen]:✅: Found Asset Catalog: \(input.stem).\(ResourceExtension.xcassets.rawValue)")
                
                print("[AssetGen]:✅: Searching for \(CatalogExtension.imageset.rawValue)...")
                let imageAssets = try FileManager.default.fetchAssets(using: ImageAssetFetcher(), atPath: inputString)
                print("[AssetGen]:✅: Found total of \(imageAssets.count) \(CatalogExtension.imageset.rawValue).")
                
                print("[AssetGen]:✅: Searching for \(CatalogExtension.colorset.rawValue)...")
                let colorAssets = try FileManager.default.fetchAssets(using: ColorAssetFetcher(), atPath: inputString)
                print("[AssetGen]:✅: Found total of \(colorAssets.count) \(CatalogExtension.colorset.rawValue).")
                
                return (imageAssets, colorAssets)
            }
            
            // 2. Reduce the array of tuples into a single tuple.
            let initialValue: ([ImageAsset], [ColorAsset]) = ([], [])
            let combinedAssets = assetsPerCatalog.reduce(initialValue) { accumulator, currentTuple in
                // Concatenate the arrays within the tuples
                let allImages = accumulator.0 + currentTuple.0
                let allColors = accumulator.1 + currentTuple.1
                return (allImages, allColors)
            }
            
            // 3. Return the final combined tuple
            return combinedAssets
        } catch {
            print("[AssetGen]:❌: Error while finding asset catalogs.")
            return ([], [])
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
