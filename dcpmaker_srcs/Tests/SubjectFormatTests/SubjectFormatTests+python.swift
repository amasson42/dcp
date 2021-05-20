import XCTest
@testable import SubjectFormat
import Foundation

extension SubjectFormatTests {

    func testFormatPythonInitVar() throws {
        let sub = SubjectPython()
        
        let initVarCodes: [(SubjectFormat.ValuedParameter, String, String)] = [
            (.bool(value: true), "myBool", "if myBool != True: exit(1)"),
            (.bool(value: false), "myBool", "if myBool != False: exit(1)"),
            (.int(value: -1), "myInt", "if myInt != -1: exit(1)"),
            (.int(value: 0), "myInt", "if myInt != 0: exit(1)"),
            (.int(value: 42), "myInt", "if myInt != 42: exit(1)"),
            (.int(value: -6546546546546), "myInt", "if myInt != -6546546546546: exit(1)"),
            (.float(value: -1.42), "myFloat", "if myFloat != -1.42: exit(1)"),
            (.float(value: -0), "myFloat", "if myFloat != -0: exit(1)"),
            (.float(value: 1), "myFloat", "if myFloat != 1: exit(1)"),
            (.float(value: 546.78), "myFloat", "if myFloat != 546.78: exit(1)"),
            (.string(value: "yay"), "myString", #"if myString != "yay": exit(1)"#),
            (.string(value: "super"), "myString", #"if myString != "super": exit(1)"#),
            (.string(value: ""), "myString", #"if myString != "": exit(1)"#),
            (.string(value: "\"- >?<"), "myString", #"if myString != "\"- >?<": exit(1)"#),
        ]

        try initVarCodes.forEach { (subVariable, varName, testCode) in
            let code = sub.format(initVariable: subVariable, toName: varName) + testCode
            let runResult = try testPython(code: code)
            XCTAssertEqual(runResult, 0, code)
        }
    }

    func testFormatPythonInitArray() throws {
        let sub = SubjectPython()

        let initVarCodes: [(SubjectFormat.ValuedParameter, String, String)] = [
            (.array_bool(value: [true, false]), "myBoolArray",
            """
if len(myBoolArray) != 2: exit(1)
if myBoolArray[0] != True: exit(1)
if myBoolArray[1] != False: exit(1)
"""),
            (.array_int(value: [0, -10, 4, 65536]), "myIntArray",
            """
if len(myIntArray) != 4: exit(1)
if myIntArray[0] != 0: exit(1)
if myIntArray[1] != -10: exit(1)
if myIntArray[2] != 4: exit(1)
if myIntArray[3] != 65536: exit(1)
"""),
            (.array_float(value: [-1.42, 0, -0, 65.78]), "myFloatArray",
            """
if len(myFloatArray) != 4: exit(1)
if myFloatArray[0] != -1.42: exit(1)
if myFloatArray[1] != 0: exit(1)
if myFloatArray[2] != -0: exit(1)
if myFloatArray[3] != 65.78: exit(1)
"""),
            (.array_string(value: ["yay", "0", "", "\" >?<"]), "myStringArray", """
if len(myStringArray) != 4: exit(1)
if myStringArray[0] != "yay": exit(1)
if myStringArray[1] != "0": exit(1)
if myStringArray[2] != "": exit(1)
if myStringArray[3] != "\\\" >?<": exit(1)
"""),
        ]

        try initVarCodes.forEach { (subVariable, varName, testCode) in
            let code = sub.format(initVariable: subVariable, toName: varName) + testCode
            let runResult = try testPython(code: code)
            XCTAssertEqual(runResult, 0, code)
        }
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
