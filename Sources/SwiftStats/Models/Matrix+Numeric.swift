extension Matrix where T: Numeric {
    
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
    
    static func + (left: Matrix<T>, right: Matrix<T>) -> Matrix<T>? {
        return combine(left: left, right: right, action: +)
    }
    
    static func - (left: Matrix<T>, right: Matrix<T>) -> Matrix<T>? {
        return combine(left: left, right: right, action: -)
    }
    
    static func * (left: Matrix<T>, right: Matrix<T>) -> Matrix<T>? {
        if left.rowLength != right.columnLength { return nil }
        
        var arr: [[T]] = []
        
        for i in 0..<left.columnLength {
            arr.append([])
            for j in 0..<right.rowLength {
                guard let dot = left.row(i) * right.column(j) else { return nil }
                arr[i].append(dot)
            }
        }
        return Matrix(arr)
    }
    
    static func determinant(_ matrix: Matrix<T>) -> T? {
        if matrix.rowLength != matrix.columnLength {
            return nil }
        switch matrix.rowLength {
        case 0:
            return 0
        case 1:
            return matrix[0,0]
        case 2:
            return matrix[0,0] * matrix[1,1] - matrix[0,1] * matrix[1,0]
        default:
            var results: [T] = []
            for i in 0..<matrix.rowLength {
                var minor: [[T]] = [[]]
                minor = matrix.value[1...].map({ [T]($0[0..<i] + $0[(i+1)...]) })
                guard let det = determinant(Matrix(minor)) else { return nil }
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
    
    func gramian() -> Matrix<T>? {
        return self * self.transpose()
    }
    
    func det() -> T? {
        return Matrix.determinant(self)
    }
    
}
