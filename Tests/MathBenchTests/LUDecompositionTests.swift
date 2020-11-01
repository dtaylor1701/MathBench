import XCTest
import MathBench

class LUDecompositionTests: XCTestCase {
    func testDecomposition3x3() {
        let a = Matrix<Double>([2,-1,-2],
                               [-4,6,3],
                               [-4,-2,8])
        guard let lu = try? LUDecomposition(a) else {
            XCTFail()
            return
        }
        let expectedP = Matrix<Double>([0,1,0],
                                       [1,0,0],
                                       [0,0,1])
        let expectedU = Matrix<Double>([-4,6,3],
                                      [0,2,-0.5],
                                      [0,0,3])
        let expectedL = Matrix<Double>([1,0,0],
                                       [-0.5,1,0],
                                       [1,-4,1])
        print("Upper: \n\(lu.upper.printString())")
        print("Lower: \n\(lu.lower.printString())")
        print("Pivot: \n\(lu.p.printString())")
        let pa = try? lu.p * a
        let luMat = try? lu.lower * lu.upper
        XCTAssertEqual(pa, luMat)
        
        XCTAssertEqual(expectedP, lu.p)
        XCTAssertEqual(expectedL, lu.lower)
        XCTAssertEqual(expectedU, lu.upper)
    }
    
    func testDecomposition2x2() {
        let a = Matrix<Double>([4,1],
                               [2,1])
        guard let lu = try? LUDecomposition(a) else {
            XCTFail()
            return
        }
        let expectedP = Matrix<Double>([1,0],
                                       [0,1])
        let expectedU = Matrix<Double>([4,1],
                                       [0,0.5])
        let expectedL = Matrix<Double>([1,0],
                                       [0.5,1])
        print("Upper: \n\(lu.upper.printString())")
        print("Lower: \n\(lu.lower.printString())")
        print("Pivot: \n\(lu.p.printString())")
        let pa = try? lu.p * a
        let luMat = try? lu.lower * lu.upper
        XCTAssertEqual(pa, luMat)
        
        XCTAssertEqual(expectedP, lu.p)
        XCTAssertEqual(expectedL, lu.lower)
        XCTAssertEqual(expectedU, lu.upper)
    }
    
    func testDecompositionAllUpper() {
        let a = Matrix<Double>([7,1,1],
                               [0,6,1],
                               [0,0,5])
        guard let lu = try? LUDecomposition(a) else {
            XCTFail()
            return
        }
        let expectedP = Matrix<Double>([1,0,0],
                                       [0,1,0],
                                       [0,0,1])
        let expectedU = Matrix<Double>([7,1,1],
                                       [0,6,1],
                                       [0,0,5])
        let expectedL = Matrix<Double>([1,0,0],
                                       [0,1,0],
                                       [0,0,1])
        print("Upper: \n\(lu.upper.printString())")
        print("Lower: \n\(lu.lower.printString())")
        print("Pivot: \n\(lu.p.printString())")
        let pa = try? lu.p * a
        let luMat = try? lu.lower * lu.upper
        XCTAssertEqual(pa, luMat)
        
        XCTAssertEqual(expectedP, lu.p)
        XCTAssertEqual(expectedL, lu.lower)
        XCTAssertEqual(expectedU, lu.upper)
    }
}
