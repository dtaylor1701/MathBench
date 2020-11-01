// Numerically find the integral of some function `f(x)` over a finite interval.
/// - Parameters:
///   - function: The function over which to integate.
///   - from: The starting value of `x` in the interval.
///   - to: The ending value of `x` in the interval.
///   - resolution: The number of slices taken to fin the result.
/// - Returns: An approximation of the integral of the provided function for input values over an interval.
public func integrate<T: BinaryFloatingPoint>(function: (T) -> T, from: T, to: T, resolution: Int = 1000) -> T {
    var result: T = 0
    let interval = (to - from) / T(resolution)

    var start = from
    var end = from + interval

    for _ in 0..<resolution {
        let nextArea = trapezoid(a: function(start), b: function(end), interval: interval)
        result += nextArea
        start += interval
        end += interval
    }

    return result
}


public func trapezoid<T: BinaryFloatingPoint>(a: T, b: T, interval: T) -> T {
    let minimum = min(a, b)
    let maximum = max(a, b)

    let side = minimum

    let top = maximum - side

    let triangle = (top * interval) / T(2)
    let base = side * interval

    return triangle + base
}
