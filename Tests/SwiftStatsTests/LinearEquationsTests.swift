import XCTest
@testable import SwiftStats

class LinearEquationsTests: XCTestCase {
    func testSolveForward() {
        let a = Matrix<Double>([1,0,0],
                               [0,1,0],
                               [0,0,1])
        let b = Matrix<Double>([3],
                               [4],
                               [5])
        let x = a.forwardSolve(b)
        
        XCTAssertEqual(x, b)
    }
    
    func testSolveBackward() {
        let a = Matrix<Double>([1,0,0],
                               [0,1,0],
                               [0,0,1])
        let b = Matrix<Double>([3],
                               [4],
                               [5])
        let x = a.backwardSolve(b)
        
        XCTAssertEqual(x, b)
    }
    
    func testSolve() {
        let a = Matrix<Double>([1,2,3],
                               [4,5,6],
                               [7,8,9])
        let b = Matrix<Double>([3],
                               [2],
                               [1])
        let x = a.solve(given: b)
    }
}
