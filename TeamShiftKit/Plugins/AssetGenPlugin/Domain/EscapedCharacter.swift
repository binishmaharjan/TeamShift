import Foundation

/// EscapeCharacter for code generation
enum EscapeCharacter: String {
    /// Represents a new line
    case newLine = "\n"
    /// Represents a tab space
    case tab = "\t"
    /// Represents a carriage return
    case carriageReturn = "\r"
    /// Represents a backspace
    case backspace = "\u{0008}"
    /// Represents a form feed
    case formFeed = "\u{000C}"
}
