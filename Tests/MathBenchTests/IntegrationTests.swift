import XCTest
import MathBench

class IntegrationTests: XCTestCase {

    func testTrapezoid() throws {

        // Square
        var a = 2.0
        var b = 2.0

        var interval = 1.0

        var e = 2.0

        XCTAssertEqual(e, trapezoid(a: a, b: b, interval: interval))

        // Small Square
        a = 0.002
        b = 0.002

        interval = 0.01

        e = 0.00002

        XCTAssertEqual(e, trapezoid(a: a, b: b, interval: interval))

        // Trapezoid with left peak
        a = 2.0
        b = 1.0

        interval = 1.0

        e = 1.5

        XCTAssertEqual(e, trapezoid(a: a, b: b, interval: interval))

        // Trapezoid with right peak
        a = 1.0
        b = 2.0

        interval = 1.0

        e = 1.5

        XCTAssertEqual(e, trapezoid(a: a, b: b, interval: interval))
    }

    func testIntegration() throws {
        let function: (Double) -> Double = { x in
            return 1
        }

        let a = 0.0
        let b = 1.0

        let e = 1.0

        XCTAssertEqual(e, integrate(function: function, from: a, to: b), accuracy: 0.0001)
    }

}
