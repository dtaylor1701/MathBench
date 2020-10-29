import XCTest
import SwiftStats

class FactorialTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFactorialZero() throws {
        let expected: Double = 1

        XCTAssertEqual(factorial(0), expected)
    }

    func testFactorialOne() throws {
        let expected: Double = 1

        XCTAssertEqual(factorial(1), expected)
    }

    func testFactorial() throws {
        let expected: Double = 120

        XCTAssertEqual(factorial(5), expected)
    }
}
