import XCTest
import SwiftStats

class LinearEquationsTests: XCTestCase {
    func testSolveForward() {
        let a = Matrix<Double>([1,0,0],
                               [1,1,0],
                               [1,1,1])
        let b = Matrix<Double>([3],
                               [4],
                               [5])
        let x = try? a.forwardSolve(b)
        
        let expected = Matrix<Double>([3],
                                      [1],
                                      [1])
        
        XCTAssertEqual(expected, x)
    }
    
    func testSolveBackward() {
        let a = Matrix<Double>([1,1,1],
                               [0,1,1],
                               [0,0,1])
        let b = Matrix<Double>([3],
                               [4],
                               [5])
        let x = try? a.backwardSolve(b)
        
        let expected = Matrix<Double>([-1],
                                      [-1],
                                      [5])
        
        XCTAssertEqual(expected, x)
    }
    
    func testSolve() {
        let a = Matrix<Double>([5,8,4],
                               [6,9,5],
                               [4,8,2])
        let b = Matrix<Double>([12],
                               [2],
                               [6])
        let x = try? a.solve(given: b)
        
        let expected = Matrix<Double>([-104],
                                      [39],
                                      [55])
        
        matricesEqual(a: expected, b: x, accuracy: 0.000001)
    }
}


extension XCTestCase {
    func matricesEqual<T>(a: Matrix<T>?, b: Matrix<T>?, accuracy: T) where T: FloatingPoint {
        guard let a = a, let b = b, a.rowCount == b.rowCount && a.columnCount == b.columnCount else {
            XCTFail("Requires non-nil matrices with the same dimensions")
            return
        }
        for i in 0..<a.rowCount {
            for j in 0..<a.columnCount {
                XCTAssertEqual(a[i,j], b[i,j], accuracy: accuracy)
            }
        }
    }
}
