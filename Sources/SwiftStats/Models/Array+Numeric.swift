public extension Array where Element: Numeric {
    static func * (left: Array<Element>, right: Array<Element>) throws -> Element {
        if left.count != right.count || left.count == 0 { throw MatrixError.mismatchedDimensions }
        var result: Element = 0
        for i in 0..<left.count {
            result += left[i] * right[i]
        }
        return result
    }
}
