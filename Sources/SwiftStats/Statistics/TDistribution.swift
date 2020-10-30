import Foundation

public struct TDistribution<T> where T: BinaryFloatingPoint {

    /// The probability of that value particular value in the distribution.
    /// - Parameters:
    ///   - t: The value in question.
    ///   - df: Degrees of the variate.
    /// - Returns: The probability of the value `t` in the distribution.
    public static func probability(for t: T, df: Int) -> T {
        let numeratorGamma: T = oneHalfGamma(df + 1)

        let denominatorFirstTerm = (T(df) * T.pi).squareRoot()
        let denominatorGamma: T = oneHalfGamma(df)
        let exponentBase = (1 + (t * t) / T(df))
        let denominatorLastTerm = exponentiation(of: exponentBase, to: df + 1).squareRoot()

        let denominator = denominatorFirstTerm * denominatorGamma * denominatorLastTerm

        return numeratorGamma / denominator
    }

    /// Approximates the cummulative probability of some value `t`
    /// being greater than or equal to a random value in the distribution. (two-tailed p-value)
    /// - Parameters:
    ///   - t: The value in question.
    ///   - n: Degrees of the variate.
    /// - Returns: The probability that a random value would be great than or equal to `t`.
    public static func cumulativeProbability(for t: T, n: Int) -> T {

        let betaX = T(n) / (T(n) + t * t)
        let incompleteBeta = incompleteBetaFunction(for: betaX, a: T(n) / T(2), b: 0.5)
        let beta: T = (oneHalfGamma(n) * oneHalfGamma(1)) / (oneHalfGamma(n + 1))
        let regularized = incompleteBeta / beta

        let totalProbability = 1.0 - 0.5 * regularized

        return (1 - totalProbability) * 2
    }
}
