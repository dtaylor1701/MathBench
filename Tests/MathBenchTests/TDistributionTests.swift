import Foundation
import XCTest
import MathBench

class TDistributionTests: XCTestCase {
    func testCumulativeProbabilityCase1() throws {

        let expected = 0.0437

        let n = 22

        let x = 2.14

        let actual: Double = TDistribution.cumulativeProbability(of: x, n: n)

        XCTAssertEqual(expected, actual, accuracy: 0.001)
    }

    func testCumulativeProbabilityCase2() throws {

        let expected = 0.0932

        let n = 1

        let x = 6.78

        let actual: Double = TDistribution.cumulativeProbability(of: x, n: n)

        XCTAssertEqual(expected, actual, accuracy: 1e-3)
    }
}

