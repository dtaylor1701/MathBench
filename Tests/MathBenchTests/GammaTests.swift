import XCTest
import MathBench

class GammaTests: XCTestCase {
    func testOne() throws {
        let expected = Double.pi.squareRoot()

        let actual: Double = oneHalfGamma(1)

        XCTAssertEqual(actual, expected, accuracy: 0.001)
    }

    func testOdd() throws {
        let expected: Double = 1133278.3889

        let actual: Double = oneHalfGamma(21)

        XCTAssertEqual(actual, expected, accuracy: 0.001)
    }

    func testEven() throws {
        let expected: Double = 39916800

        let actual: Double = oneHalfGamma(24)

        XCTAssertEqual(actual, expected)
    }
}
