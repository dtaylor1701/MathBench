import Foundation

/// The sign function.
/// - Returns: -1, 1, or 0 for a value less than, greater than, or equal to zero respectively.
public func sgn<T: Numeric & Comparable>(_ x: T) -> T {
    if x > 0 {
        return 1
    } else if x < 0 {
        return -1
    } else {
        return 0
    }
}

/// Exponentiation to positive integer powers.
public func exponentiation<T: FloatingPoint>(of value: T, to exponent: Int) -> T {
    var result: T = 1
    for _ in 0..<exponent {
        result = result * value
    }
    return result
}

func squared<T>(_ value: T) -> T where T: FloatingPoint {
    return value * value
}

public func sumOfSquares<T: FloatingPoint>(x: [T], mean: T) -> T {
    return x.map({ squared($0 - mean) }).reduce(0, +)
}
