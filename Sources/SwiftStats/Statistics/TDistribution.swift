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
}
