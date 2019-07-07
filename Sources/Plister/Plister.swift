import Foundation
import Files
import ShellOut

/// Helper to deal with updating plists using PlistBuddy.
public struct Plister {
    
    /// Errors which may occur attempting to load plists.
    ///
    /// - couldNotLoadData: Could not load the contents of the file as Data.
    /// - couldNotTransformDataToDictionary: The contents of the file are improperly formatted
    ///                                      and could not be transformed into a dictionary.
    public enum Error: Swift.Error {
        case couldNotLoadData(path: String)
        case couldNotTransformDataToDictionary(path: String)
    }
    
    private static func runPlistBuddyCommand(_ command: String, for file: File) throws {
        try shellOut(to: "/usr/libexec/Plistbuddy -c \(command) \(file.path)")
    }
    
    /// Sets the plist value for a given key in a given file.
    /// NOTE: The key must already exist in the file to be updated by this script.
    ///
    /// - Parameters:
    ///   - value: The value to set
    ///   - key: The key to set it for
    ///   - file: The file to set it in.
    public static func setValue(_ value: AnyHashable, for key: String, in file: File) throws {
        try self.runPlistBuddyCommand("\"Set :\(key) \(value)\"", for: file)
    }
    
    /// Saves the plist file to disk
    ///
    /// - Parameter file: the plist file to save.
    public static func save(file: File) throws {
        try self.runPlistBuddyCommand("Save", for: file)
    }
    
    /// Loads the given plist file as a `[String: AnyHashable]` dictionary.
    ///
    /// - Parameter file: The plist file to load.
    /// - Returns: The parsed dictionary.
    public static func loadAsDictionary(file: File) throws -> [String: AnyHashable] {
        guard let data = FileManager.default.contents(atPath: file.path) else {
            throw Plister.Error.couldNotLoadData(path: file.path)
        }
        
        var plistFormat: PropertyListSerialization.PropertyListFormat = .xml
        let plist = try PropertyListSerialization.propertyList(from: data,
                                                               options: .mutableContainersAndLeaves,
                                                               format: &plistFormat)
        
        guard let plistDict = plist as? [String: AnyHashable] else {
            throw Plister.Error.couldNotTransformDataToDictionary(path: file.path)
        }
        
        return plistDict
    }
}
