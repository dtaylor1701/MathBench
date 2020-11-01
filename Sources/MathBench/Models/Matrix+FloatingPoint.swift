import Foundation

public extension Matrix where T: FloatingPoint {
    func det(given decomposition: LUDecomposition<T>? = nil) throws -> T {
        if !isSquare { throw MatrixError.squareMatrixRequired }
        let lu = try decomposition ?? LUDecomposition(self)
        var r: T = 1
        for i in 0..<columnCount {
            r *= lu.upper[i,i]
        }
        let sign: T = lu.exchanges.isMultiple(of: 2) ? 1 : -1
        return r * sign
    }
    
    func inverse(using lu: LUDecomposition<T>? = nil) throws -> Matrix<T> {
        if !isSquare { throw MatrixError.squareMatrixRequired }
        let lu = try lu ?? LUDecomposition(self)
        let n = self.rowCount
        var columns: [[T]] = []
        let I = Matrix<T>(identityWithSize: n)
        for i in 0..<n {
            let columnI = Matrix<T>(columns: [I.column(i)])
            let column = try solve(given: columnI, using: lu).column(0)
            columns.append(column)
        }
        return Matrix<T>(columns: columns)
    }
}
