extension Matrix where T: FloatingPoint {
    
    func forwardSolve(_ b: Matrix<T>) -> Matrix<T>? {
        guard b.columnLength == self.columnLength else { return nil}
        let n = b.columnLength
        var x = Matrix<T>(n,1)
        for i in 0..<n {
            var sum: T = 0
            for j in 0..<i {
                sum += self[i,j] * x[j,0]
            }
            x[i,0] = (b[i,0] - sum ) / self[i,i]
        }
        return x
    }
    
    func backwardSolve(_ b: Matrix<T>) -> Matrix<T>? {
        guard b.columnLength == self.columnLength else { return nil}
        let n = b.columnLength
        var x = Matrix<T>(n,1)
        for i in (0..<n).reversed() {
            var sum: T = 0
            for j in (0..<i).reversed() {
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
    func solve(given b: Matrix<T>, using lu: LUDecomposition<T>? = nil) -> Matrix<T>? {
        guard let lu = lu ?? LUDecomposition(self) else { return nil }
        //Ly == Pb
        guard let pb = lu.p * b else { return nil }
        guard let y = lu.lower.forwardSolve(pb) else { return nil }
        guard let x = lu.upper.backwardSolve(y) else { return nil}
        return x
    }
}
