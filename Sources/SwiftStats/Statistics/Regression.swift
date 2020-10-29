import Foundation

enum RegressionError: Error {
    case insufficientData
}

public struct Regression<T> where T: BinaryFloatingPoint {
    
    public let x: Matrix<T>
    public let y: Matrix<T>
    
    /// Residuals
    public let residuals: Matrix<T>
    /// Coeffecients
    public let beta: Matrix<T>
    /// Predicted Values
    public let predicted: Matrix<T>
    /// Degrees of freedom
    public let df: Int
    /// Standard Error
    public let stdError: T
    /// R Squared
    public let rSquared: T
    /// Adjusted R Squared
    public let adjRSquared: T
    /// Model Sum of Squares
    public let mss: T
    /// Total Sum of Suares
    public let tss: T
    /// Error some of squares
    public let ess: T
    /// Standard error of the coefficients
    public let stdErrorOfCoeff: Matrix<T>
    /// T values for the coefficients
    public let tValuesOfCoeff: Matrix<T>
    /// Probabilty values from the t-distribution
    public let pValuesOfCoeff: Matrix<T>
    /// Mean Squared Error
    public let mse: T
    /// F-test
    /// https://en.wikipedia.org/wiki/F-test
    public let fStat: T
    /// Probability in the f distribution.
    public let probability: T
    
    public init(x: Matrix<T>, y: Matrix<T>) throws {
        self.x = x
        self.y = y
        if x.rowCount != y.rowCount { throw ComputationalError.mismatchedDimensions }
        let n = x.rowCount
        let p = x.columnCount
        df = n - p

        // There must be more than zero degrees of freedom.
        guard df > 0 else { throw RegressionError.insufficientData }

        let yColumn = y.column(0)
        let mean = yColumn.reduce(0, +) / T(y.rowCount)
        beta = try Regression.beta(for: x, given: y)
        residuals = try Regression.risiduals(of: beta, for: x, given: y)
        predicted = try x * beta
        
        mss = predicted.column(0).map({ square($0 - mean) }).reduce(0, +)
        tss = y.column(0).map({ square($0 - mean) }).reduce(0, +)

        let meanError = residuals.column(0).reduce(0, +) / T(residuals.rowCount)
        ess = residuals.column(0).map({ square($0 - meanError) }).reduce(0, +)

        rSquared = mss/tss
        mse = ess / T(df)
        stdError = sqrt(mse)
        fStat = (mss / T(p - 1)) / mse

        let v1 = p - 1
        let v2 = df

        probability = FDistribution.cumulativeProbability(for: fStat, n: v1, m: v2)

        // Adjusted R Squared
        let nAdj: T = T(n - 1) / T(n - p)
        let adjustment: T =  nAdj * (1 - rSquared)
        adjRSquared = 1 - adjustment

        stdErrorOfCoeff = try ((mse * x.gramian().inverse()).diagonal()).map(sqrt)

        let tValues = try beta.column(0).asVector() * stdErrorOfCoeff.column(0).map { 1 / $0 }.asVector()
        tValuesOfCoeff = tValues.asComlumnMatrix()

        let r = n - 1
        let pValues = tValues.value.map { TDistribution.probability(for: $0, df: r) }

        pValuesOfCoeff = Matrix(columns: [pValues])
    }
    
    /// Solve for the coeffecients of regression given regressors y
    ///
    /// - Parameter x: input
    /// - Parameter y: Regressors
    /// - Returns: The coeffecients of regression
    public static func beta(for x: Matrix<T>, given y: Matrix<T>) throws -> Matrix<T> {
        let ig = try x.gramian().inverse()
        let m = try x.moment(given: y)
        return try ig * m
    }
    
    public static func risiduals(of beta: Matrix<T>, for x: Matrix<T>, given y: Matrix<T>) throws -> Matrix<T> {
        var r: [[T]] = []
        for i in 0..<y.rowCount {
            let s = try y[i,0] - x.row(i) * beta.column(0)
            r.append([s])
        }
        return Matrix<T>(r)
    }
}


/// Exponentiation to positive integer powers.
public func exponentiation<T: BinaryFloatingPoint>(of value: T, to exponent: Int) -> T {
    var result: T = 1
    for _ in 0..<exponent {
        result = result * value
    }
    return result
}


func square<T>(_ value: T) -> T where T: BinaryFloatingPoint {
    return value * value
}
