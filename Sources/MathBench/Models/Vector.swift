import Foundation

public struct Vector<T: Comparable>: Equatable {
    public private(set) var value: [T]
    public var length: Int {
        return value.count
    }

    public subscript(i: Int) -> T {
        get {
            return value[i]
        }
        set {
            value[i] = newValue
        }
    }

    public init(_ value: T...) {
        self.value = value
    }

    public init(_ value: [T]) {
        self.value = value
    }

    func asComlumnMatrix() -> Matrix<T> {
        return Matrix(columns: [value])
    }
}


public extension Vector where T: Numeric {
    static func + (left: Vector<T>, right: Vector<T>) throws -> Vector<T> {
        guard left.length == right.length else {
            throw MatrixError.mismatchedDimensions
        }
        var values: [T] = []
        for i in 0..<left.length {
            values.append(left[i] + right[i])
        }
        return Vector(values)
    }

    static func * (left: Vector<T>, right: Vector<T>) throws -> Vector<T> {
        guard left.length == right.length else {
            throw MatrixError.mismatchedDimensions
        }
        var values: [T] = []
        for i in 0..<left.length {
            values.append(left[i] * right[i])
        }
        return Vector(values)
    }
}


public extension Array where Element: Comparable {
    func asVector() -> Vector<Element> {
        return Vector(self)
    }
}
