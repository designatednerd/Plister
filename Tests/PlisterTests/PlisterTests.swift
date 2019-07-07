import XCTest
import Files
import ShellOut
@testable import Plister

final class PlisterTests: XCTestCase {
    private let fileName = "Sample.plist"
    
    private lazy var file: File = {
        let testFile = try! File(path: #file)
        let testsFolder = testFile.parent!
        let plistFile = try! testsFolder.file(atPath: "Sample.plist")
        
        return plistFile
    }()
    
    func testLoadingContents() throws {
       let dict = try Plister.loadAsDictionary(file: self.file)
        
        XCTAssertNotNil(dict)
        XCTAssertEqual(dict.keys.count, 5)
        
        guard let string = dict["string_key"] as? String else {
            XCTFail("Value for `string_key` was missing or wrong type!")
            return
        }
        
        XCTAssertEqual(string, "String Value")
        
        guard let boolean = dict["boolean_key"] as? Bool else {
            XCTFail("Value for `boolean_key` was missing or wrong type!")
            return
        }
        
        XCTAssertTrue(boolean)
        
        guard let number = dict["number_key"] as? Double else {
            XCTFail("Value for `number_key` was missing or wrong type!")
            return
        }
        
        XCTAssertEqual(number, 1234.56, accuracy: 0.001)
        
        guard let array = dict["array_key"] as? [String] else {
            XCTFail("Value for `array_key` was missing or wrong type!")
            return
        }
        
        XCTAssertEqual(array, ["Zero", "One"])
        
        guard let dictionary = dict["dictionary_key"] as? [String: AnyHashable] else {
            XCTFail("Value for `dictionary_key` was missing or wrong type!")
            return
        }
        
        XCTAssertEqual(dictionary[
        "inner_dictionary_string"] as? String, "Inner Dictionary String Value")
    }
    
    func testChangingExistingValue() throws {
        let stringKey = "string_key"
        let initialDict = try Plister.loadAsDictionary(file: self.file)
        XCTAssertEqual(initialDict[stringKey] as? String, "String Value")
        
        let updatedValue = "Totally new value!"
        try Plister.setValue(updatedValue, for: stringKey, in: self.file)
//        try Plister.save(file: self.file)
        
        let reloadedDict = try Plister.loadAsDictionary(file: self.file)
        guard let reloadedString = reloadedDict[stringKey] as? String else {
            XCTFail("Value for `\(stringKey)` was missing or incorrect type")
            return
        }
        
        XCTAssertEqual(reloadedString, updatedValue)
    }
    
    // I am for linux compatibility!
    static var allTests = [
        ("testLoadingContents", testLoadingContents),
        ("testChangingExistingValue", testChangingExistingValue),
    ]
}
