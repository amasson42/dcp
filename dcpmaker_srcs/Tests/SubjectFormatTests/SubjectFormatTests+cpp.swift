import XCTest
@testable import SubjectFormat
import Foundation

extension SubjectFormatTests {

    func testFormatCppInitVar() throws {
        let sub = SubjectCpp()

        let initVarCodes: [(SubjectFormat.ValuedParameter, String, String)] = [
            (.bool(value: true), "myBool", "if (myBool != true) return 1;"),
            (.bool(value: false), "myBool", "if (myBool != false) return 1;"),
            (.int(value: -1), "myInt", "if (myInt != -1) return 1;"),
            (.int(value: 0), "myInt", "if (myInt != 0) return 1;"),
            (.int(value: 42), "myInt", "if (myInt != 42) return 1;"),
            (.int(value: -6546546546546), "myInt", "if (myInt != (int)-6546546546546) return 1;"),
            (.float(value: -1.42), "myFloat", "if (myFloat != (float)-1.42) return 1;"),
            (.float(value: -0), "myFloat", "if (myFloat != (float)-0) return 1;"),
            (.float(value: 1), "myFloat", "if (myFloat != (float)1) return 1;"),
            (.float(value: 546.78), "myFloat", "if (myFloat != (float)546.78) return 1;"),
            (.string(value: "yay"), "myString", #"if (myString != "yay") return 1;"#),
            (.string(value: "super"), "myString", #"if (myString != "super") return 1;"#),
            (.string(value: ""), "myString", #"if (myString != "") return 1;"#),
            (.string(value: "\"- >?<"), "myString", #"if (myString != "\"- >?<") return 1;"#),
        ]

        try initVarCodes.forEach { (subVariable, varName, testCode) in
            let code = sub.format(initVariable: subVariable, toName: varName) + testCode
            let runResult = try testCpp(code: code)
            XCTAssertEqual(runResult.compile, 0, code)
            if runResult.compile == 0 {
                XCTAssertEqual(runResult.execution, 0, code)
            }
        }
    }

    func testFormatCppInitArray() throws {
        let sub = SubjectCpp()

        let initVarCodes: [(SubjectFormat.ValuedParameter, String, String)] = [
            (.array_bool(value: [true, false]), "myBoolArray",
            """
if (myBoolArray.size() != 2) return 1;
if (myBoolArray[0] != true) return 1;
if (myBoolArray[1] != false) return 1;
"""),
            (.array_int(value: [0, -10, 4, 65536]), "myIntArray",
            """
if (myIntArray.size() != 4) return 1;
if (myIntArray[0] != 0) return 1;
if (myIntArray[1] != -10) return 1;
if (myIntArray[2] != 4) return 1;
if (myIntArray[3] != 65536) return 1;
"""),
            (.array_float(value: [-1.42, 0, -0, 65.78]), "myFloatArray",
            """
if (myFloatArray.size() != 4) return 1;
if (myFloatArray[0] != (float)-1.42) return 1;
if (myFloatArray[1] != (float)0) return 1;
if (myFloatArray[2] != (float)-0) return 1;
if (myFloatArray[3] != (float)65.78) return 1;
"""),
            (.array_string(value: ["yay", "0", "", "\" >?<"]), "myStringArray", """
if (myStringArray.size() != 4) return 1;
if (myStringArray[0] != "yay") return 1;
if (myStringArray[1] != "0") return 1;
if (myStringArray[2] != "") return 1;
if (myStringArray[3] != "\\\" >?<") return 1;
"""),
        ]

        try initVarCodes.forEach { (subVariable, varName, testCode) in
            let code = sub.format(initVariable: subVariable, toName: varName) + testCode
            let runResult = try testCpp(code: code)
            XCTAssertEqual(runResult.compile, 0, code)
            if runResult.compile == 0 {
                XCTAssertEqual(runResult.execution, 0, code)
            }
        }
    }
    
    func testFormatCppInitMatrix() throws {
        let sub = SubjectCpp()
        
        let initVarCodes: [(SubjectFormat.ValuedParameter, String, String)] = [
            (
                .matrix_bool(value: [[true, false], [false, true]]),
                "myBoolMat",
                """
if (myBoolMat.size() != 2) return 1;
if (myBoolMat[0].size() != 2) return 1;
if (myBoolMat[1].size() != 2) return 1;
if (myBoolMat[0][0] != true) return 1;
if (myBoolMat[0][1] != false) return 1;
if (myBoolMat[1][0] != false) return 1;
if (myBoolMat[1][1] != true) return 1;
return 0;
"""
            ),
            (
                .matrix_int(value: [[11, -12], [21, -22]]),
                "myIntMat",
                """
if (myIntMat.size() != 2) return 1;
if (myIntMat[0].size() != 2) return 1;
if (myIntMat[1].size() != 2) return 1;
if (myIntMat[0][0] != 11) return 1;
if (myIntMat[0][1] != -12) return 1;
if (myIntMat[1][0] != 21) return 1;
if (myIntMat[1][1] != -22) return 1;
return 0;
"""
            ),
            (
                .matrix_float(value: [[1.24, -0.42], [-0, 19.47]]),
                "myFloatMat",
                """
if (myFloatMat.size() != 2) return 1;
if (myFloatMat[0].size() != 2) return 1;
if (myFloatMat[1].size() != 2) return 1;
if (myFloatMat[0][0] != (float)1.24) return 1;
if (myFloatMat[0][1] != (float)-0.42) return 1;
if (myFloatMat[1][0] != (float)-0) return 1;
if (myFloatMat[1][1] != (float)19.47) return 1;
return 0;
"""
            ),
            (
                .matrix_string(value: [["00", "01", "02"], ["10", "11", "12"], ["20", "21", "22"]]),
                "myStrMat",
                """
if (myStrMat.size() != 3) return 1;
if (myStrMat[0].size() != 3) return 1;
if (myStrMat[1].size() != 3) return 1;
if (myStrMat[2].size() != 3) return 1;
if (myStrMat[0][0] != "00") return 1;
if (myStrMat[1][0] != "10") return 1;
if (myStrMat[2][0] != "20") return 1;
if (myStrMat[0][1] != "01") return 1;
if (myStrMat[1][1] != "11") return 1;
if (myStrMat[2][1] != "21") return 1;
if (myStrMat[0][2] != "02") return 1;
if (myStrMat[1][2] != "12") return 1;
if (myStrMat[2][2] != "22") return 1;
return 0;
"""
            )
        ]
        
        try initVarCodes.forEach { (subVariable, varName, testCode) in
            let code = sub.format(initVariable: subVariable, toName: varName) + testCode
            let runResult = try testCpp(code: code)
            XCTAssertEqual(runResult.compile, 0, code)
            if runResult.compile == 0 {
                XCTAssertEqual(runResult.execution, 0, code)
            }
        }
    }
}

fileprivate func testCpp(code: String) throws -> (compile: Int32, execution: Int32) {
    return try FileManager.default.withTemporaryDirectory {
        let fileContent =
            """

#include <iostream>
#include <vector>

int main() {
\(code)
}

"""
        try fileContent.write(toFile: "main.cpp", atomically: true, encoding: .utf8)
        let compileResult = try shell("g++ main.cpp")
        let executionResult = try shell("./a.out")
        return (compileResult.code, executionResult.code)
    }
}

