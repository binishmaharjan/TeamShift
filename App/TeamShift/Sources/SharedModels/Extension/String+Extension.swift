import Foundation

// MARK: Regex
extension String {
    public var isEmail: Bool {
        // Create the Regex object
        // Using #/.../# literal is often cleaner if the pattern is static
        // let regex = try Regex(emailPattern)
        let regex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/
        
        // Use wholeMatch(of:) to check if the ENTIRE string matches
        return self.wholeMatch(of: regex) != nil
    }
}

// MARK: Helpers
extension String {
    public var toName: String {
        guard isEmail else { return self }
        // Takes the prefix of the string as long as the character is not '@'
        return String(prefix { $0 != "@" })
    }
}
