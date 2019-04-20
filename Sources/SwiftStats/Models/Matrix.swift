import Foundation

struct Matrix<T: Comparable>: Equatable {
    var value: [[T]]
    let rowLength: Int
    let columnLength: Int
    
    var isSquare: Bool {
        return rowLength == columnLength
    }
    
    subscript(i: Int, j: Int) -> T {
        get {
            return value[i][j]
        }
        set {
            value[i][j] = newValue
        }
    }
    
    init(_ arrays: [T]...) {
        self.init(arrays)
    }
    
    init(_ arrays: [[T]]) {
        let min = arrays.map({ $0.count }).min() ?? 0
        rowLength = min
        columnLength = arrays.count
        value = arrays.map({ [T]($0[0..<min]) })
    }
    
    func row(_ index: Int) -> [T] {
        return value[index]
    }
    
    func column(_ index: Int) -> [T] {
        return value.map({ $0[index] })
    }
    
    func transpose() -> Matrix<T> {
        var newArrays: [[T]] = []
        for i in 0..<rowLength {
            var arr: [T] = []
            for j in 0..<columnLength {
                arr.append(value[j][i])
            }
            newArrays.append(arr)
        }
        return Matrix(newArrays)
    }
    
    func printString() -> String {
        let result = value.map({ printString(row: $0) }).joined(separator: "\n")
        return result
    }
    
    func printString<T>(row: [T]) -> String {
        let result = row.map({ "\($0)" }).joined(separator: ",")
        return "|\(result)|"
    }
    
    static func combine(left: Matrix<T>, right: Matrix<T>, action: (T,T) -> T) -> Matrix<T>? {
        var result = left
        if left.rowLength != right.rowLength || left.columnLength != right.columnLength { return nil }
        for i in 0..<left.columnLength {
            for j in 0..<left.rowLength {
                result[i,j] = action(left[i,j], right[i,j])
            }
        }
        return result
    }
}
