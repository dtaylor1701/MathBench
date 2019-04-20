extension Array where Element: Numeric {
    static func * (left: Array<Element>, right: Array<Element>) -> Element? {
        if left.count != right.count, left.count == 0 { return nil }
        var result: Element = 0
        for i in 0..<left.count {
            result += left[i] * right[i]
        }
        return result
    }
}
