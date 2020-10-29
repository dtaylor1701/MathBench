@testable import SwiftStats
import XCTest

class CaseTests: XCTestCase {
    
    var x: Matrix<Double>!
    var y: Matrix<Double>!
    
    override func setUp() {
        x = Matrix([1, 1.47, 2.1609],
                   [1, 1.50, 2.2500],
                   [1, 1.52, 2.3104],
                   [1, 1.55, 2.4025],
                   [1, 1.57, 2.4649],
                   [1, 1.60, 2.5600],
                   [1, 1.63, 2.6569],
                   [1, 1.65, 2.7225],
                   [1, 1.68, 2.8224],
                   [1, 1.70, 2.8900],
                   [1, 1.73, 2.9929],
                   [1, 1.75, 3.0625],
                   [1, 1.78, 3.1684],
                   [1, 1.80, 3.2400],
                   [1, 1.83, 3.3489])
        y = Matrix([52.21],
                   [53.12],
                   [54.48],
                   [55.84],
                   [57.20],
                   [58.57],
                   [59.93],
                   [61.29],
                   [63.11],
                   [64.47],
                   [66.28],
                   [68.10],
                   [69.92],
                   [72.19],
                   [74.46])
    }
    
    override func tearDown() {
        x = nil
        y = nil
    }
    
    func testTranspose() {
        let e = Matrix( [1.0000, 1.00, 1.0000, 1.0000, 1.0000, 1.00, 1.0000, 1.0000, 1.0000, 1.00, 1.0000, 1.0000, 1.0000, 1.00, 1.0000],
                        [1.4700, 1.50, 1.5200, 1.5500, 1.5700, 1.60, 1.6300, 1.6500, 1.6800,  1.70, 1.7300, 1.7500, 1.7800,  1.80, 1.8300],
                        [2.1609, 2.25, 2.3104, 2.4025, 2.4649, 2.56, 2.6569, 2.7225, 2.8224,  2.89, 2.9929, 3.0625, 3.1684,  3.24, 3.3489])
        XCTAssertEqual(x.transpose(), e)
    }
    
    func testGramian() throws {
        let e = Matrix([15.0, 24.76000, 41.05320],
                       [24.7600, 41.05320, 68.36793],
                       [41.0532, 68.36793, 114.34829])
        let g = try x.gramian()
        matricesEqual(a: e, b: g, accuracy: 0.0001)
    }
    
    func testLUD1() throws {
        let g = try x.gramian()
        
        let lu = try LUDecomposition(g)
        
        let ep = Matrix<Double>([0,0,1],
                                [1,0,0],
                                [0,1,0])
        
        let eu = Matrix<Double>([41.0532, 68.36793, 114.34829],
                                [0, -0.22024392739177756, -0.7273274619274588],
                                [0, 0, -0.0005402173847550706])
        let el = Matrix<Double>([1, 0, 0],
                                [0.3653795562830669, 1, 0],
                                [0.6031198542379158, 0.821162146397459, 1])
        
        matricesEqual(a: ep, b: lu.p, accuracy: 0.0001)
        matricesEqual(a: el, b: lu.lower, accuracy: 0.0001)
        matricesEqual(a: eu, b: lu.upper, accuracy: 0.0001)
    }
    
    func testLUD() throws {
        let el = Matrix<Double>([1,0,0],
                                [0.36537955628307, 1, 0],
                                [0.60311985423792, 0.8211621463972, 1])
        let eu = Matrix<Double>([41.0532, 68.36793, 114.34829],
                                [0, -0.2202439273918, -0.7273274619275],
                                [0, 0, -0.000540217384885])
        
        let g = try x.gramian()
        
        let lu = try LUDecomposition(g)
        
        matricesEqual(a: try lu.p * g, b: try lu.lower * lu.upper, accuracy: 0.00001)
        
        matricesEqual(a: el, b: lu.lower, accuracy: 0.0001)
        matricesEqual(a: eu, b: lu.upper, accuracy: 0.0001)
    }
    
    func testInverseGramian() throws {
        let e = Matrix([4201.862, -5107.727, 1545.3217],
                       [-5107.727, 6214.549, -1881.8590],
                       [1545.322, -1881.859, 570.3576])
        let g = try x.gramian()
        let ig = try g.inverse()
        let i = Matrix<Double>(identityWithSize: g.columnCount)
        matricesEqual(a: i, b: try g * ig, accuracy: 0.000001)
        matricesEqual(a: e, b: ig, accuracy: 0.001)
    }
    
    func testBeta() throws {
        let eb = Matrix<Double>([128.8128],
                                [-143.1620],
                                [61.9603])
        let r = try Regression(x: x, y: y)
        
        matricesEqual(a: eb, b: r.beta, accuracy: 0.0001)
    }
    
    func testRSquared() throws {
        let eR2 = 0.9989
        let r = try Regression(x: x, y: y)

        XCTAssertEqual(eR2, r.rSquared, accuracy: 0.0001)
    }
    
    func testAdjRSquared() throws {
        let eR = 0.9987
        let r = try Regression(x: x, y: y)
        
        XCTAssertEqual(eR, r.adjRSquared, accuracy: 0.0001)
    }
    
    func testStdErr() throws {
        let eStdErr = 0.2516
        let r = try Regression(x: x, y: y)
        
        XCTAssertEqual(eStdErr, r.stdError, accuracy: 0.0001)
    }
    
    func testMSS() throws {
        let eMSS = 692.61
        let r = try Regression(x: x, y: y)
        
        XCTAssertEqual(eMSS, r.mss, accuracy: 0.01)
    }
    
    func testTSS() throws {
        let eTSS = 693.37
        let r = try Regression(x: x, y: y)
        
        XCTAssertEqual(eTSS, r.tss, accuracy: 0.01)
    }
    
    func testStdErrCoef() throws {
        let e = Matrix<Double>([16.3083],
                               [19.8332],
                               [6.0084])
        let r = try Regression(x: x, y: y)
        
        matricesEqual(a: e, b: r.stdErrorOfCoeff, accuracy: 0.0001)
    }
    
}

