import XCTest
import MathBench

class BetaTests: XCTestCase {
    func testCase1() throws {
        let expected = 0.090909090909090909081138199579

        let z = 0.9811385459533608
        let a = 1.0
        let b = 11.0

        let beta = incompleteBetaFunction(for: z, a: a, b: b)

        XCTAssertEqual(beta, expected, accuracy: 1e-6)
    }

}
