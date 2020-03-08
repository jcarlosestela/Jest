import XCTest
@testable import Jest

final class JestTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Jest().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
