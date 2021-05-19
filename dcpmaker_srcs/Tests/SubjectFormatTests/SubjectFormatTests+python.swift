import XCTest
@testable import SubjectFormat
import Foundation

extension SubjectFormatTests {

    func testFormatPythonInitVar() throws {
        // TODO: make tests
    }

    func testFormatPythonInitArray() throws {
        // TODO: make tests
    }

    func testFormatPythonInitMatrix() throws {
        let sub = SubjectPython()
        
        let initVarCodes: [(SubjectFormat.ValuedParameter, String, String)] = [
            (
                .matrix_string(value: [["00", "01", "02"], ["10", "11", "12"], ["20", "21", "22"]]),
                "myStrMat",
                """
if len(myStrMat) != 3: exit(1)
if len(myStrMat[0]) != 3: exit(1)
if len(myStrMat[1]) != 3: exit(1)
if len(myStrMat[2]) != 3: exit(1)
if myStrMat[0][0] != "00": exit(1)
if myStrMat[1][0] != "10": exit(1)
if myStrMat[2][0] != "20": exit(1)
if myStrMat[0][1] != "01": exit(1)
if myStrMat[1][1] != "11": exit(1)
if myStrMat[2][1] != "21": exit(1)
if myStrMat[0][2] != "02": exit(1)
if myStrMat[1][2] != "12": exit(1)
if myStrMat[2][2] != "22": exit(1)
"""
            ),
            (
                .matrix_bool(value: [[true, false], [false, true]]),
                "myBoolMat",
                """
if len(myBoolMat) != 2: exit(1)
if len(myBoolMat[0]) != 2: exit(1)
if len(myBoolMat[1]) != 2: exit(1)
if myBoolMat[0][0] != True: exit(1)
if myBoolMat[0][1] != False: exit(1)
if myBoolMat[1][0] != False: exit(1)
if myBoolMat[1][1] != True: exit(1)
"""
            ),
            (
                .matrix_int(value: [[11, -12], [21, -22]]),
                "myIntMat",
                """
if len(myIntMat) != 2: exit(1)
if len(myIntMat[0]) != 2: exit(1)
if len(myIntMat[1]) != 2: exit(1)
if myIntMat[0][0] != 11: exit(1)
if myIntMat[0][1] != -12: exit(1)
if myIntMat[1][0] != 21: exit(1)
if myIntMat[1][1] != -22: exit(1)
"""
            ),
            (
                .matrix_float(value: [[1.24, -0.42], [-0, 19.47]]),
                "myFloatMat",
                """
if len(myFloatMat) != 2: exit(1)
if len(myFloatMat[0]) != 2: exit(1)
if len(myFloatMat[1]) != 2: exit(1)
if myFloatMat[0][0] != 1.24: exit(1)
if myFloatMat[0][1] != -0.42: exit(1)
if myFloatMat[1][0] != -0: exit(1)
if myFloatMat[1][1] != 19.47: exit(1)
"""
            )
        ]
        
        try initVarCodes.forEach { (subVariable, varName, testCode) in
            let code = sub.format(initVariable: subVariable, toName: varName) + testCode
            let runResult = try testPython(code: code)
            XCTAssertEqual(runResult, 0, code)
        }
    }
}

fileprivate func testPython(code: String) throws -> Int32 {
    return try FileManager.default.withTemporaryDirectory {
        let fileContent = """
\(code)
"""
        try fileContent.write(toFile: "main.py", atomically: true, encoding: .utf8)
        let executionResult = try shell("python3 main.py")
        return executionResult.code
    }
}
