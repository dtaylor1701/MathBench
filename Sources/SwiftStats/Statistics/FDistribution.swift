import Foundation

public struct FDistribution<T> where T: BinaryFloatingPoint  {

    /// Approximates the cummulative probability of some value `x`
    /// being greater than or equal to a random value in the distribution.
    /// - Parameters:
    ///   - x: The value in question.
    ///   - n: Degrees of the first variate.
    ///   - m: Degrees of freedome of the second variate.
    /// - Returns: The probability that a random value would be great than or equal to `x`.
    public static func cumulativeProbability(for x: T, n: Int, m: Int) -> T {
        let z: T = (T(n) * x) / (T(m) + T(n) * x)
        let a: T = T(n) / T(2)
        let b: T = T(m) / T(2)

        let incompleteBeta: T = incompleteBetaFunction(for: z, a: a, b: b)

        let beta: T = (oneHalfGamma(n) * oneHalfGamma(m)) / (oneHalfGamma(n + m))

        let result = T(1) - incompleteBeta / beta

        // When the result is sufficiently small, the innacuracy of the floating point value causes it to be negative.
        // For this reason such values are considered close enough to zero.
        guard result > 0 else { return 0 }

        return result
    }

    /// The probability of that value particular value in the distribution.
    /// - Parameters:
    ///   - f: The value in question.
    ///   - n: Degrees of the first variate.
    ///   - m: Degrees of freedome of the second variate.
    /// - Returns: The probability of the value `f` in the distribution.
    public static func probability(for f: T, n: Int, m: Int) -> T {
        let n1 = exponentiation(of: T(m), to: m).squareRoot()
        let n2 = exponentiation(of: T(n), to: n).squareRoot()
        let n3 = exponentiation(of: f, to: n).squareRoot() * T(1) / f

        let d1 = exponentiation(of: (T(m) + T(n) * f), to: n + m).squareRoot()
        let dBeta: T = (oneHalfGamma(n) * oneHalfGamma(m)) / (oneHalfGamma(2 + m))
        return (n1 * n2 * n3) / (d1 * dBeta)
    }

    /// Alternative approache to probability(for f: T, n: Int, m: Int)
    public static func __probability0(for f: T, n: Int, m: Int) -> T {
        let nFirstTerm: T = oneHalfGamma(n + m)
        let nSecondTerm = exponentiation(of: T(n), to: n).squareRoot()
        let nThirdTerm = exponentiation(of: T(m), to: m).squareRoot()
        let nFourthTerm = exponentiation(of: f, to: n).squareRoot() * T(1) / f

        let dFirstTerm: T = oneHalfGamma(n)
        let dSecondTerm: T = oneHalfGamma(m)
        let dThirdTerm = exponentiation(of: (T(m) + T(n) * f), to: n + m).squareRoot()

        let numerator = (nFirstTerm * nSecondTerm * nThirdTerm * nFourthTerm)

        let denominator = (dFirstTerm * dSecondTerm * dThirdTerm)

        return numerator / denominator
    }

    /// Alternative approache to probability(for f: T, n: Int, m: Int)
    public static func __probability1(for x: T, n: Int, m: Int) -> T {
        guard x > 0 else { return 0 }
        let x1 = exponentiation(of: (T(n) * x), to: n)
        let x2 = exponentiation(of: T(m), to: m)

        let x3 = exponentiation(of: (T(n) * x + T(m)), to: n + m)

        let numerator = (x1 * x2 / x3).squareRoot()

        let dBeta: T = (oneHalfGamma(n) * oneHalfGamma(m)) / (oneHalfGamma(n + m))
        let denominator = x * dBeta

        return numerator / denominator
    }
}
