import Foundation

public struct Matrix<T: Comparable>: Equatable {
    public var value: [[T]]
    public let columnCount: Int
    public let rowCount: Int
    
    public var isSquare: Bool {
        return columnCount == rowCount
    }
    
    public subscript(i: Int, j: Int) -> T {
        get {
            return value[i][j]
        }
        set {
            value[i][j] = newValue
        }
    }
    
    public init(_ rows: [T]...) {
        self.init(rows)
    }
    
    public init(_ rows: [[T]]) {
        let min = rows.map({ $0.count }).min() ?? 0
        columnCount = min
        rowCount = rows.count
        value = rows.map({ [T]($0[0..<min]) })
    }
    
    public init(columns: [[T]]) {
        let transpose = Matrix<T>(columns).transpose()
        self.init(transpose.value)
    }
    
    public func row(_ index: Int) -> [T] {
        return value[index]
    }
    
    public func column(_ index: Int) -> [T] {
        return value.map({ $0[index] })
    }
    
    public func transpose() -> Matrix<T> {
        var newArrays: [[T]] = []
        for i in 0..<columnCount {
            var arr: [T] = []
            for j in 0..<rowCount {
                arr.append(value[j][i])
            }
            newArrays.append(arr)
        }
        return Matrix(newArrays)
    }
    
    public func printString() -> String {
        let result = value.map({ printString(row: $0) }).joined(separator: "\n")
        return result
    }
    
    public func printString<T>(row: [T]) -> String {
        let result = row.map({ "\($0)" }).joined(separator: ",")
        return "|\(result)|"
    }
    
    public static func combine(left: Matrix<T>, right: Matrix<T>, action: (T,T) -> T) throws -> Matrix<T> {
        var result = left
        if left.columnCount != right.columnCount || left.rowCount != right.rowCount { throw ComputationalError.mismatchedDimensions }
        for i in 0..<left.rowCount {
            for j in 0..<left.columnCount {
                result[i,j] = action(left[i,j], right[i,j])
            }
        }
        return result
    }
    
    mutating func swap(row firstIndex: Int, with secondIndex: Int) {
        let temp = value[firstIndex]
        value[firstIndex] = value[secondIndex]
        value[secondIndex] = temp
    }
}
