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
    
}
