import Foundation
import XCTest
import SwiftStats

class TDistributionTests: XCTestCase {
    func testFDistribution() throws {

        let expected = 0.0437

        let n = 22

        let x = 2.14

        let actual: Double = TDistribution.cumulativeProbability(for: x, n: n)

        XCTAssertEqual(expected, actual, accuracy: 0.001)
    }
}
