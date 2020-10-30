public struct LUDecomposition<T> where T: FloatingPoint {
    public let upper: Matrix<T>
    public let lower: Matrix<T>
    public let p: Matrix<T>
    public let exchanges: Int
    
    public init(_ m: Matrix<T>) throws {
        if m.columnCount != m.rowCount { throw MatrixError.squareMatrixRequired }
        let n = m.columnCount
        var matrix = m
        var upper = Matrix<T>(identityWithSize: n)
        var lower = Matrix<T>(identityWithSize: n)
        var p = Matrix<T>(identityWithSize: n)
        var exchanges = 0
        
        // Decomposing matrix into Upper and Lower
        // triangular matrix
        for i in 0..<n {
            
            // Pivot
            var maxU: T = 0
            var row = i
            for r in i..<n {
                var thisU = matrix[r,i]
                for q in 0..<i {
                    thisU -= matrix[r,q] * matrix[q,r]
                }
                if abs(thisU) > maxU {
                    maxU = abs(thisU)
                    row = r
                }
            }
            
            if row != i {
                exchanges += 1
                matrix.swap(row: i, with: row)
                p.swap(row: i, with: row)
            }
        }
        for i in 0..<n {
            for j in i..<n { //Determine U across row i
                upper[i,j] = matrix[i,j]
                for q in 0..<i {
                    upper[i,j] -= lower[i,q] * upper[q,j]
                }
            }
            for j in (i+1)..<n { //Determine L down column i
                lower[j,i] = matrix[j,i];
                for q in 0..<i {
                    lower[j,i] -= lower[j,q] * upper[q,i]
                }
                lower[j,i] = lower[j,i] / upper[i,i]
            }
        }
        self.upper = upper
        self.lower = lower
        self.p = p
        self.exchanges = exchanges
    }
}
