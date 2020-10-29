public extension Matrix where T: Numeric {
    
    init(_ rows: Int, _ columns: Int) {
        let zero: T = 0
        let row = Array<T>(repeating: zero, count: columns)
        let arrays = Array<[T]>(repeating: row, count: rows)
        self.init(arrays)
    }
    
    init(identityWithSize n: Int) {
        self.init(n,n)
        for i in 0..<n {
            self[i,i] = 1
        }
    }
    
    static func + (left: Matrix<T>, right: Matrix<T>) throws -> Matrix<T> {
        return try combine(left: left, right: right, action: +)
    }
    
    static func - (left: Matrix<T>, right: Matrix<T>) throws -> Matrix<T> {
        return try combine(left: left, right: right, action: -)
    }
    
    static func * (left: Matrix<T>, right: Matrix<T>) throws -> Matrix<T> {
        if left.columnCount != right.rowCount { throw ComputationalError.mismatchedDimensions }
        
        var arr: [[T]] = []
        
        for i in 0..<left.rowCount {
            arr.append([])
            for j in 0..<right.columnCount {
                let dot = try left.row(i) * right.column(j)
                arr[i].append(dot)
            }
        }
        return Matrix(arr)
    }
    
    static func * (left: T, right: Matrix<T>) -> Matrix<T> {
        var result = Matrix<T>(right.rowCount, right.columnCount)
        for i in 0..<right.rowCount {
            for j in 0..<right.columnCount {
                result[i,j] = left * right[i,j]
            }
        }
        return result
    }

    static func determinant(_ matrix: Matrix<T>) throws -> T {
        if !matrix.isSquare { throw ComputationalError.squareMatrixRequired }
        switch matrix.columnCount {
        case 0:
            return 0
        case 1:
            return matrix[0,0]
        case 2:
            return matrix[0,0] * matrix[1,1] - matrix[0,1] * matrix[1,0]
        default:
            var results: [T] = []
            for i in 0..<matrix.columnCount {
                var minor: [[T]] = [[]]
                minor = matrix.value[1...].map({ [T]($0[0..<i] + $0[(i+1)...]) })
                let det = try determinant(Matrix(minor))
                results.append(matrix[0,i] * det)
            }
            var result = results[0]
            var sign = -1
            for i in 1..<results.count {
                if sign == 1 {
                    result += results[i]
                } else {
                    result -= results[i]
                }
                sign = sign * -1
            }
            return result
        }
    }
    
    /// https://en.wikipedia.org/wiki/Gramian_matrix
    ///
    /// - Returns: The gramian matrix
    func gramian() throws -> Matrix<T> {
        return try self.transpose() * self
    }
    
    func det() throws -> T {
        return try Matrix.determinant(self)
    }
}
