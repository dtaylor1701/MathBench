public extension String.StringInterpolation {
    mutating func appendingInterpolation<T>(_ value: Matrix<T>) {
        appendLiteral(value.printString())
    }
}
