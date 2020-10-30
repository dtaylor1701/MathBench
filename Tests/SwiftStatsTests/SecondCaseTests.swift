import XCTest
import SwiftStats

class SecondCaseTests: XCTestCase {

    var x: Matrix<Double>!
    var y: Matrix<Double>!

    override func setUp() {
        x = Matrix([1,2,50],
                   [1,8,110],
                   [1,11,120],
                   [1,10,550],
                   [1,8,295],
                   [1,4,200],
                   [1,2,375],
                   [1,2,52],
                   [1,9,100],
                   [1,8,300],
                   [1,4,412],
                   [1,11,400],
                   [1,12,500],
                   [1,2,360],
                   [1,4,205],
                   [1,4,400],
                   [1,20,600],
                   [1,1,585],
                   [1,10,540],
                   [1,15,250],
                   [1,15,290],
                   [1,16,510],
                   [1,17,590],
                   [1,6,100],
                   [1,5,400])
        y = Matrix([9.95],
                   [24.45],
                   [31.75],
                   [35.00],
                   [25.02],
                   [16.86],
                   [14.38],
                   [9.60],
                   [24.35],
                   [27.50],
                   [17.08],
                   [37.00],
                   [41.95],
                   [11.66],
                   [21.65],
                   [17.89],
                   [69.00],
                   [10.30],
                   [34.93],
                   [46.59],
                   [44.88],
                   [54.12],
                   [56.63],
                   [22.13],
                   [21.15])
    }

    override func tearDown() {
        x = nil
        y = nil
    }

    func testGramian() throws {
        let e = Matrix([25.0, 206.0, 8294.0],
                       [206.0, 2396.0, 77177.0],
                       [8294.0, 77177.0, 3531848.0])
        let g = try x.gramian()
        matricesEqual(a: e, b: g, accuracy: 0.0001)
    }

    func testBeta() throws {
        let eb = Matrix<Double>([2.26379143],
                                [2.74426964],
                                [0.01252781])
        let r = try Regression(x: x, y: y)

        matricesEqual(a: eb, b: r.beta, accuracy: 0.0001)
    }

    func testResiduals() throws {
        let e = Matrix([1.57],
                       [-1.15],
                       [-2.20],
                       [-1.60],
                       [-2.89],
                       [1.11],
                       [1.93],
                       [1.20],
                       [-3.86],
                       [-0.48],
                       [-1.32],
                       [-0.46],
                       [0.49],
                       [-0.60],
                       [5.84],
                       [-0.36],
                       [4.33],
                       [-2.04],
                       [-1.54],
                       [-0.03],
                       [-2.18],
                       [1.56],
                       [0.32],
                       [2.15],
                       [0.15])

        let r = try Regression(x: x, y: y)

        matricesEqual(a: r.residuals, b: e, accuracy: 0.1)
    }

    func testStdErrorCoefs() throws {
        let e = Matrix([[1.060],
                        [0.09352],
                        [0.002798]])

        let r = try Regression(x: x, y: y)

        matricesEqual(a: r.stdErrorOfCoeff, b: e, accuracy: 0.0001)
    }

    func testStandardError() throws {
        let e = 2.288

        let r = try Regression(x: x, y: y)

        XCTAssertEqual(r.stdError, e, accuracy: 0.001)
    }

    func testRSquared() throws {
        let e = 0.981

        let r = try Regression(x: x, y: y)

        XCTAssertEqual(r.rSquared, e, accuracy: 0.001)
    }

    func testAdjustedRSquared() throws {
        let e = 0.979

        let r = try Regression(x: x, y: y)

        XCTAssertEqual(r.adjRSquared, e, accuracy: 0.001)
    }

    func testMSS() throws {
        let eMSS = 5990.8
        let r = try Regression(x: x, y: y)

        XCTAssertEqual(eMSS, r.mss, accuracy: 0.1)
    }

    func testESS() throws {
        let eMSS = 115.2
        let r = try Regression(x: x, y: y)

        XCTAssertEqual(eMSS, r.ess, accuracy: 0.1)
    }

    func testTSS() throws {
        let eTSS = 6105.9
        let r = try Regression(x: x, y: y)

        XCTAssertEqual(eTSS, r.tss, accuracy: 0.1)
    }

    func testMSE() throws {
        let eMSE = 5.2
        let r = try Regression(x: x, y: y)

        XCTAssertEqual(eMSE, r.mse, accuracy: 0.1)
    }

    func testFStat() throws {
        let eFStat = 572.17

        let r = try Regression(x: x, y: y)

        XCTAssertEqual(eFStat, r.fStat, accuracy: 0.01)
    }

    func testFProbability() throws {
        let e = 0.000

        let r = try Regression(x: x, y: y)
        XCTAssertEqual(r.fProbability, e, accuracy: 0.01)
    }

    func testTValues() throws {
        let e = Matrix([[2.136],
                        [29.343],
                        [4.477]])
        let r = try Regression(x: x, y: y)
        matricesEqual(a: r.tValuesOfCoeff, b: e, accuracy: 0.001)
    }

    func testPValues() throws {
        let e = Matrix([[0.044099],
                        [0.00],
                        [1.881e-4]])
        let r = try Regression(x: x, y: y)
        matricesEqual(a: r.pValuesOfCoeff, b: e, accuracy: 0.00001)
    }
}
