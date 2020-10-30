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
