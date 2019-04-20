struct LUDecomposition<T> where T: FloatingPoint {
    let upper: Matrix<T>
    let lower: Matrix<T>
    let p: Matrix<T>
    let exchanges: Int
    
    init?(_ matrix: Matrix<T>) {
        if matrix.rowLength != matrix.columnLength { return nil }
        let n = matrix.rowLength
        var matrix = matrix
        var upper = Matrix<T>(n,n)
        var lower = Matrix<T>(n,n)
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
                var q = 0
                while q < i {
                    thisU -= matrix[r,q] * matrix[q,r]
                    q += 1
                }
                if abs(thisU) > maxU {
                    maxU = abs(thisU)
                    row = r
                }
            }
            if row != i {
                exchanges += 1
                for q in 0..<n {
                    var temp = p[i,q]
                    p[i,q] = p[row,q]
                    p[row,q] = temp
                    temp = matrix[i,q]
                    matrix[i,q] = matrix[row,q]
                    matrix[row,q] = temp
                }
            }
            
            // Upper Triangular
            for j in i..<n {
                //Lower row i * Upper row j
                guard let dot = lower.row(i) * upper.column(j) else { return nil }
                // Evaluating U(i, j)
                upper[i,j] = matrix[i,j] - dot
            }
            
            // Lower Triangular
            for j in i..<n {
                if (i == j) {
                    lower[i,i] = 1 // Diagonal as 1
                } else {
                    //Lower row j * Upper row i
                    guard let dot = lower.row(j) * upper.column(i) else { return nil }
                    
                    // Evaluating L(k, i)
                    lower[j,i] = (matrix[j,i] - dot) / upper[i,i]
                }
            }
        }
        self.upper = upper
        self.lower = lower
        self.p = p
        self.exchanges = exchanges
    }
}
