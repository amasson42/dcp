import XCTest
@testable import SubjectFormat
import Foundation

final class SubjectFormatTests: XCTestCase {
    
    static var allTests = [
        ("testTmpDirectory", testTmpDirectory),

        ("testFormatSwiftInitVar", testFormatSwiftInitVar),
        ("testFormatSwiftInitArray", testFormatSwiftInitArray),
        ("testFormatSwiftInitMatrix", testFormatSwiftInitMatrix),

        ("testFormatPythonInitVar", testFormatPythonInitVar),
        ("testFormatPythonInitArray", testFormatPythonInitArray),
        ("testFormatPythonInitMatrix", testFormatPythonInitMatrix),

        ("testFormatCppInitVar", testFormatCppInitVar),
        ("testFormatCppInitArray", testFormatCppInitArray),
        ("testFormatCppInitMatrix", testFormatCppInitMatrix),
    ]
    
    func testFormat() throws {
        
    }
    
}
