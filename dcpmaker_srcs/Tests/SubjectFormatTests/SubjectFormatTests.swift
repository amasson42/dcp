import XCTest
@testable import SubjectFormat
import Foundation

final class SubjectFormatTests: XCTestCase {
    
    // MARK: testTmpDirectory
    func testTmpDirectory() throws {
        let FMD = FileManager.default
        
        let pwdBefore = FMD.currentDirectoryPath
        let tmpDir1: String = FMD.withTemporaryDirectory {
            return FMD.currentDirectoryPath
        }
        let pwdBetween = FMD.currentDirectoryPath
        let (tmpDir2, tmpDir3, pwdInception): (String, String, String) = FMD.withTemporaryDirectory {
            
            let dir2 = FMD.currentDirectoryPath
            
            let dir3 = FMD.withTemporaryDirectory {
                return FMD.currentDirectoryPath
            }
            
            do {
                try FMD.createDirectory(atPath: FMD.currentDirectoryPath + "/tmplol", withIntermediateDirectories: true, attributes: nil)
                XCTAssertTrue(FMD.changeCurrentDirectoryPath(FMD.currentDirectoryPath + "/tmplol"))
            } catch {}
            let incept = FMD.currentDirectoryPath
            
            return (dir2, dir3, incept)
            
        }
        let pwdAfter = FMD.currentDirectoryPath
        
        XCTAssertNotEqual(tmpDir1, tmpDir2)
        XCTAssertNotEqual(tmpDir2, tmpDir3)
        XCTAssertNotEqual(pwdBefore, tmpDir1)
        XCTAssertNotEqual(tmpDir2, pwdInception)
        XCTAssertNotEqual(pwdInception, pwdAfter)
        XCTAssertEqual(pwdBefore, pwdBetween)
        XCTAssertEqual(pwdBetween, pwdAfter)
    }
    
    func testFormat() throws {
        
    }
    
    // MARK: testFormatSwiftInitMatrix
    
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
    
    // MARK: testFormatPythonInitMatrix
    
    func testFormatPythonInitMatrix() throws {
        let sub = SubjectPython()
        
        let initVarCodes: [(SubjectFormat.ValuedParameter, String, String)] = [
            (
                .matrix_string(value: [["00", "01", "02"], ["10", "11", "12"], ["20", "21", "22"]]),
                "myStrMat",
                // TODO: make it all
                """
if len(myStrMat) != 3:
    exit(1)
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
    
    // MARK: testFormatCppInitMatrix
    
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

