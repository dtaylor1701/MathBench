import XCTest
import MathBench

class MathTests: XCTestCase {
    func testDotProduct(){
        let a = [3,4,5,6]
        let b = [4,2,4,5]

        let res = try? a * b
        XCTAssertEqual(res, 70)
    }
    
    func testInvalidDotProduct() {
        let a = [3,4,5,6]
        let b = [4,2,4,5,3]
        
        let res = try? a * b
        XCTAssertEqual(res, nil)
    }
}
