import XCTest
@testable import SubjectFormat
import Foundation

extension SubjectFormatTests {
    
    func testFormatSwiftInitMatrix() throws {
        let sub = SubjectSwift()
        
        let initVarCodes: [(SubjectFormat.ValuedParameter, String, String)] = [
            (
                .matrix_string(value: [["00", "01", "02"], ["10", "11", "12"], ["20", "21", "22"]]),
                "myStrMat",
                """
if (myStrMat.count != 3) { exit(1) }
if (myStrMat[0].count != 3) { exit(1) }
if (myStrMat[1].count != 3) { exit(1) }
if (myStrMat[2].count != 3) { exit(1) }
if (myStrMat[0][0] != "00") { exit(1) }
if (myStrMat[1][0] != "10") { exit(1) }
if (myStrMat[2][0] != "20") { exit(1) }
if (myStrMat[0][1] != "01") { exit(1) }
if (myStrMat[1][1] != "11") { exit(1) }
if (myStrMat[2][1] != "21") { exit(1) }
if (myStrMat[0][2] != "02") { exit(1) }
if (myStrMat[1][2] != "12") { exit(1) }
if (myStrMat[2][2] != "22") { exit(1) }
"""
            ),
            (
                .matrix_bool(value: [[true, false], [false, true]]),
                "myBoolMat",
                """
if (myBoolMat.count != 2) { exit(1) }
if (myBoolMat[0].count != 2) { exit(1) }
if (myBoolMat[1].count != 2) { exit(1) }
if (myBoolMat[0][0] != true) { exit(1) }
if (myBoolMat[0][1] != false) { exit(1) }
if (myBoolMat[1][0] != false) { exit(1) }
if (myBoolMat[1][1] != true) { exit(1) }
"""
            ),
            (
                .matrix_int(value: [[11, -12], [21, -22]]),
                "myIntMat",
                """
if (myIntMat.count != 2) { exit(1) }
if (myIntMat[0].count != 2) { exit(1) }
if (myIntMat[1].count != 2) { exit(1) }
if (myIntMat[0][0] != 11) { exit(1) }
if (myIntMat[0][1] != -12) { exit(1) }
if (myIntMat[1][0] != 21) { exit(1) }
if (myIntMat[1][1] != -22) { exit(1) }
"""
            ),
            (
                .matrix_float(value: [[1.24, -0.42], [-0, 19.47]]),
                "myFloatMat",
                """
if (myFloatMat.count != 2) { exit(1) }
if (myFloatMat[0].count != 2) { exit(1) }
if (myFloatMat[1].count != 2) { exit(1) }
if (myFloatMat[0][0] != Float(1.24)) { exit(1) }
if (myFloatMat[0][1] != Float(-0.42)) { exit(1) }
if (myFloatMat[1][0] != Float(-0)) { exit(1) }
if (myFloatMat[1][1] != Float(19.47)) { exit(1) }
"""
            )
        ]
        
        try initVarCodes.forEach { (subVariable, varName, testCode) in
            let code = sub.format(initVariable: subVariable, toName: varName) + testCode
            let runResult = try testSwift(code: code)
            XCTAssertEqual(runResult.compile, 0, code)
            XCTAssertEqual(runResult.execution, 0, code)
        }
    }
    
}


fileprivate func testSwift(code: String) throws -> (compile: Int32, execution: Int32) {
    return try FileManager.default.withTemporaryDirectory {
        let fileContent =
            """

import Foundation

\(code)

"""
        try fileContent.write(toFile: "main.swift", atomically: true, encoding: .utf8)
        let compileResult = try shell("swiftc main.swift -o a.out")
        let executionResult = try shell("./a.out")
        return (compileResult.code, executionResult.code)
    }
}
