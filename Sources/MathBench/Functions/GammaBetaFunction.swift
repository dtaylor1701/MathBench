import Foundation

/// Calculates gamma for positive integsers multiplied by 1/2.
public func oneHalfGamma<T: BinaryFloatingPoint>(_ n: Int) -> T {
    if n.isMultiple(of: 2) {
        return factorial(Int(n / 2) - 1)
    } else {
        var result: T = T.pi.squareRoot()
        let end = Int((n - 1) / 2)
        guard end > 0 else {
            return result
        }
        let alpha: T = T(n) / T(2)
        for i in 1...end {
            result = result * (alpha - T(i))
        }
        return result
    }
}

public func factorial<T: BinaryFloatingPoint>(_ n: Int) -> T {
    switch n {
    case 0:
        return 1
    case 1:
        return 1
    default:
        return T(n) * factorial(n - 1)
    }
}

/// Finds the incomplete beta function using numerical integration.
public func incompleteBetaFunction<T: BinaryFloatingPoint>(for z: T, a: T, b: T) -> T {
    let function: (T) -> T = { u in
        let firstTerm = exponentiation(of: u, to: a - 1)
        let secondTerm = exponentiation(of: 1 - u, to: b - 1)
        return firstTerm * secondTerm
    }

    return integrate(function: function, from: 0, to: z, resolution: 10000)
}
