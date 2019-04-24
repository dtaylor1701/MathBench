import XCTest
import SwiftStats

class MatrixTests: XCTestCase {
    func testPrint() {
        let matrix = Matrix([0,1,2,3],
                            [4,6,2,7],
                            [9,3,5,2],
                            [6,9,2,4],
                            [0,2,3,2])
        print(matrix.printString())
    }
    
    func testRowLength() {
        let matrix = Matrix([0,1,2,3],
                            [4,6,2,7],
                            [9,3,5,2],
                            [6,9,2,4],
                            [0,2,3,2])
        
        XCTAssertEqual(matrix.columnCount, 4)
    }
    
    func testRowLengthUnequal() {
        let matrix = Matrix([0,1,2,3],
                            [4,6,2],
                            [9,3,5,2],
                            [6,9,2,4,6],
                            [0,2,3,2])
        
        XCTAssertEqual(matrix.columnCount, 3)
    }
    
    func testColumnLength() {
        let matrix = Matrix([0,1,2,3],
                            [4,6,2,7],
                            [9,3,5,2],
                            [6,9,2,4],
                            [0,2,3,2])
        
        XCTAssertEqual(matrix.rowCount, 5)
    }
    
    func testColumnInit() {
        let columns = [[1, 2, 3],
                       [3, 4, 5],
                       [6, 7, 8]]
        let a = Matrix<Int>(columns: columns)
        let expected = Matrix<Int>([1, 3, 6],
                                   [2, 4, 7],
                                   [3, 5, 8])
        XCTAssertEqual(expected, a)
    }
    
    func testTranspose() {
        let originalMatrix = Matrix([0,1,2,3],
                                    [4,6,2,7],
                                    [9,3,5,2],
                                    [6,9,2,4],
                                    [0,2,3,2])
        let matrix = originalMatrix.transpose()
        XCTAssertEqual(matrix.columnCount, 5)
        XCTAssertEqual(matrix.rowCount, 4)
    }
    
    func testAdd() {
        let matrix1 = Matrix([0,1,2,3],
                             [4,6,2,7],
                             [9,3,5,2],
                             [6,9,2,4],
                             [0,2,3,2])
        let matrix2 = Matrix([0,1,2,3],
                             [4,6,2,7],
                             [9,3,5,2],
                             [6,9,2,4],
                             [0,2,3,2])
        let expectedMatrix = Matrix([0,2,4,6],
                                    [8,12,4,14],
                                    [18,6,10,4],
                                    [12,18,4,8],
                                    [0,4,6,4])
        let matrix = try? matrix1 + matrix2
        XCTAssertEqual(matrix, expectedMatrix)
    }
    
    func testSubtract() {
        let matrix1 = Matrix([0,1,2,3],
                             [4,6,2,7],
                             [9,3,5,2],
                             [6,9,2,4],
                             [0,2,3,2])
        let matrix2 = Matrix([0,1,2,3],
                             [4,6,2,7],
                             [9,3,5,2],
                             [6,9,2,4],
                             [0,2,3,2])
        let expectedMatrix = Matrix([0,0,0,0],
                                    [0,0,0,0],
                                    [0,0,0,0],
                                    [0,0,0,0],
                                    [0,0,0,0])
        let matrix = try? matrix1 - matrix2
        print(matrix?.printString())
        XCTAssertEqual(matrix, expectedMatrix)
    }
    
    func testMultiply() {
        let a = Matrix([2,3],
                       [4,5])
        let b = Matrix([4,5,6,4],
                       [7,3,2,1])
        let expectedResult = Matrix([29,19,18,11],
                                    [51,35,34,21])
        let matrix = try? a * b
        XCTAssertEqual(matrix, expectedResult)
    }
    
    func testDetTwoXTwo() {
        let a = Matrix([2,3],
                       [4,5])
        let det = try? a.det()
        XCTAssertEqual(det, -2)
    }
    
    func testDetOneXOne() {
        let a = Matrix([1])
        
        XCTAssertEqual(try? a.det(), 1)
    }
    
    func testDetFourXFour() {
        let a = Matrix([0,1,2],
                       [4,6,2],
                       [9,3,5])
        let det = try? a.det()
        XCTAssertEqual(det, -86)
    }
    
    func testDetTwoXTwoLU() {
        let a = Matrix<Double>([2,3],
                               [4,5])
        let det = try? a.det(given: nil)
        XCTAssertEqual(det, -2)
    }
    
    func testDetOneXOneLU() {
        let a = Matrix<Double>([1])
        
        XCTAssertEqual(try? a.det(given: nil), 1)
    }
    
    func testDetFourXFourLU() {
        let a = Matrix<Double>([0,1,2],
                               [4,6,2],
                               [9,3,5])
        let det = try? a.det(given: nil)
        XCTAssertEqual(det, -86)
    }
    
    func testSubscriptLU() {
        let a = Matrix([0,1,2],
                       [4,6,2],
                       [9,3,5])
        
        XCTAssertEqual(a[0,0], 0)
        XCTAssertEqual(a[0,1], 1)
        XCTAssertEqual(a[0,2], 2)
        XCTAssertEqual(a[1,0], 4)
        XCTAssertEqual(a[1,1], 6)
        XCTAssertEqual(a[1,2], 2)
        XCTAssertEqual(a[2,0], 9)
        XCTAssertEqual(a[2,1], 3)
        XCTAssertEqual(a[2,2], 5)
    }
    
    func testAssignment() {
        var a = Matrix<Int>(3, 3)
        
        a[0,0] = 8
        a[0,1] = 1
        a[0,2] = 2
        a[1,0] = 4
        a[1,1] = 6
        a[1,2] = 2
        a[2,0] = 9
        a[2,1] = 3
        a[2,2] = 5
        
        XCTAssertEqual(a, Matrix([8,1,2],
                                 [4,6,2],
                                 [9,3,5]))
    }
    
    func testInverse() {
        let a = Matrix<Double>([2,4],
                               [2,3])
        let expected = Matrix<Double>([-1.5, 2],
                                      [1, -1])
        let inverse = try? a.inverse()
        matricesEqual(a: expected, b: inverse, accuracy: 0.000001)
    }
}
