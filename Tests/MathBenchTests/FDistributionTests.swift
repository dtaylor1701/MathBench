import Foundation
import XCTest
import MathBench

class FDistributionTests: XCTestCase {
    func testFDistribution() throws {

        let expected = 0.42243

        let v1 = 4
        let v2 = 31

        let x = 1.0

        let actual: Double = FDistribution.cumulativeProbability(of: x, n: v1, m: v2)

        XCTAssertEqual(expected, actual, accuracy: 0.0001)
    }

    func testFDistributionLongTail() throws {

        let expected = 0.000000

        let v1 = 2
        let v2 = 22

        let x = 572.2

        let actual: Double = FDistribution.cumulativeProbability(of: x, n: v1, m: v2)

        XCTAssertEqual(expected, actual, accuracy: 0.0000000001)
    }
}
