public extension Matrix where T: FloatingPoint {
    
    func forwardSolve(_ b: Matrix<T>) throws -> Matrix<T> {
        guard b.rowCount == self.rowCount else { throw MatrixError.mismatchedDimensions }
        let n = b.rowCount
        var x = Matrix<T>(n,1)
        for i in 0..<n {
            var sum: T = 0
            for j in 0..<i {
                sum += self[i,j] * x[j,0]
            }
            x[i,0] = (b[i,0] - sum) / self[i,i]
        }
        return x
    }
    
    func backwardSolve(_ b: Matrix<T>) throws -> Matrix<T> {
        guard b.rowCount == self.rowCount else { throw MatrixError.mismatchedDimensions }
        let n = b.rowCount
        var x = Matrix<T>(n,1)
        for i in (0..<n).reversed() {
            var sum: T = 0
            for j in (i..<n).reversed() {
                sum += self[i,j] * x[j,0]
            }
            x[i,0] = (b[i,0] - sum ) / self[i,i]
        }
        return x
    }
    
    /// Solves equations of the form Ax = b
    ///
    /// - Parameters:
    ///   - b: the resulting matrix
    ///   - lu: a lower upper decomposition of the matrix A
    /// - Returns: The matix x
    func solve(given b: Matrix<T>, using lu: LUDecomposition<T>? = nil) throws -> Matrix<T> {
        let lu = try lu ?? LUDecomposition(self)
        //Ly == Pb
        let pb = try lu.p * b
        let y = try lu.lower.forwardSolve(pb)
        let x = try lu.upper.backwardSolve(y)
        return x
    }
    
    /// https://en.wikipedia.org/wiki/Moment_matrix
    ///
    /// - Parameter y: Regressors
    /// - Returns: The moment matrix
    func moment(given y: Matrix<T>) throws -> Matrix<T> {
        return try transpose() * y
    }
}
