import Foundation

public enum MatrixError: Error {
    case mismatchedDimensions
    case squareMatrixRequired
}

public struct Matrix<T: Comparable>: Equatable {
    public private(set) var rows: [[T]]
    public private(set) var columnCount: Int
    public private(set) var rowCount: Int

    public var columns: [[T]] {
        return self.transpose().rows
    }
    
    public var isSquare: Bool {
        return columnCount == rowCount
    }
    
    public subscript(i: Int, j: Int) -> T {
        get {
            return rows[i][j]
        }
        set {
            rows[i][j] = newValue
        }
    }
    
    public init(_ rows: [T]...) {
        self.init(rows)
    }
    
    public init(_ rows: [[T]]) {
        let min = rows.map({ $0.count }).min() ?? 0
        columnCount = min
        rowCount = rows.count
        self.rows = rows.map({ [T]($0[0..<min]) })
    }
    
    public init(columns: [[T]]) {
        let transpose = Matrix<T>(columns).transpose()
        self.init(transpose.rows)
    }
    
    public func row(_ index: Int) -> [T] {
        return rows[index]
    }
    
    public func column(_ index: Int) -> [T] {
        return rows.map({ $0[index] })
    }
    
    public func transpose() -> Matrix<T> {
        var newArrays: [[T]] = []
        for i in 0..<columnCount {
            var arr: [T] = []
            for j in 0..<rowCount {
                arr.append(rows[j][i])
            }
            newArrays.append(arr)
        }
        return Matrix(newArrays)
    }
    
    public func printString() -> String {
        let result = rows.map({ printString(row: $0) }).joined(separator: "\n")
        return result
    }
    
    public func printString<T>(row: [T]) -> String {
        let result = row.map({ "\($0)" }).joined(separator: ",")
        return "|\(result)|"
    }
    
    public static func combine(left: Matrix<T>, right: Matrix<T>, action: (T,T) -> T) throws -> Matrix<T> {
        var result = left
        if left.columnCount != right.columnCount || left.rowCount != right.rowCount { throw MatrixError.mismatchedDimensions }
        for i in 0..<left.rowCount {
            for j in 0..<left.columnCount {
                result[i,j] = action(left[i,j], right[i,j])
            }
        }
        return result
    }
    
    public mutating func swap(row firstIndex: Int, with secondIndex: Int) {
        let temp = rows[firstIndex]
        rows[firstIndex] = rows[secondIndex]
        rows[secondIndex] = temp
    }
    
    public func diagonal() throws -> Matrix<T> {
        if !isSquare { throw MatrixError.squareMatrixRequired }
        var column: [T] = []
        for i in 0..<rowCount {
            column.append(self[i,i])
        }
        return Matrix<T>(columns: [column])
    }
    
    public func map<U>(_ transform: (T) -> U) -> Matrix<U> {
        var newRows: [[U]] = []
        for row in rows {
            var thisRow: [U] = []
            for i in 0..<columnCount {
                thisRow.append(transform(row[i]))
            }
            newRows.append(thisRow)
        }
        return Matrix<U>(newRows)
    }

    public mutating func append(row: [T]) throws {
        if row.count != columnCount {
            throw MatrixError.mismatchedDimensions
        }
        rows.append(row)
        rowCount += 1
    }

    public mutating func append(column: [T]) throws {
        if column.count != rowCount {
            throw MatrixError.mismatchedDimensions
        }
        for i in 0..<rows.count {
            rows[i].append(column[i])
        }
        columnCount += 1
    }
}
