import XCTest
@testable import SwiftStats

class MathTests: XCTestCase {
    func testDotProduct(){
        let a = [3,4,5,6]
        let b = [4,2,4,5]

        let res = a * b
        XCTAssertEqual(res, 70)
    }
    
    func testInvalidDotProduct() {
        let a = [3,4,5,6]
        let b = [4,2,4,5,3]
        
        let res = a * b
        XCTAssertEqual(res, nil)
    }
}
