import XCTest

import JestTests

var tests = [XCTestCaseEntry]()
tests += JestTests.allTests()
XCTMain(tests)
