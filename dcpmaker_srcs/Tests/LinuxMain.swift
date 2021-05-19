import XCTest

import DcpmakerTests
import SubjectFormatTests

var tests = [XCTestCaseEntry]()
tests += DcpmakerTests.allTests()
tests += SubjectFormatTests.allTests()
XCTMain(tests)
