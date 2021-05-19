import XCTest
@testable import SubjectFormat
import Foundation

extension SubjectFormatTests {
    
    func testFormatCppInitMatrix() throws {
        let sub = SubjectCpp()
        
        let initVarCodes: [(SubjectFormat.ValuedParameter, String, String)] = [
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
            ),
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
if (myFloatMat[0].size() != 2) return 2;
if (myFloatMat[1].size() != 2) return 3;
if (myFloatMat[0][0] != (float)1.24) return 4;
if (myFloatMat[0][1] != (float)-0.42) return 5;
if (myFloatMat[1][0] != (float)-0) return 6;
if (myFloatMat[1][1] != (float)19.47) return 7;
return 0;
"""
            )
        ]
        
        try initVarCodes.forEach { (subVariable, varName, testCode) in
            let code = sub.format(initVariable: subVariable, toName: varName) + testCode
            let runResult = try testCpp(code: code)
            XCTAssertEqual(runResult.compile, 0, code)
            XCTAssertEqual(runResult.execution, 0, code)
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

