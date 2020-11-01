import Foundation

public enum RegressionError: Error {
    case insufficientData
}

/// Generates regression analysis of the form Y = βX + ε.
/// https://en.wikipedia.org/wiki/Regression_analysis
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
    /// https://en.wikipedia.org/wiki/Standard_error
    public let stdError: T
    /// R Squared
    /// https://en.wikipedia.org/wiki/Coefficient_of_determination
    public let rSquared: T
    /// Adjusted R Squared
    /// https://en.wikipedia.org/wiki/Coefficient_of_determination#Adjusted_R2
    public let adjRSquared: T
    /// Model Sum of Squares
    public let modelSumOfSquares: T
    /// Total Sum of Suares
    public let totalSumOfSquares: T
    /// Error some of squares
    public let errorSumOfSquares: T
    /// Standard error of the coefficients
    public let stdErrorOfCoeff: Matrix<T>
    /// T values for the coefficients
    /// https://en.wikipedia.org/wiki/Student%27s_t-test
    public let tValuesOfCoeff: Matrix<T>
    /// Probabilty values from the t-distribution
    public let pValuesOfCoeff: Matrix<T>
    /// Mean Squared Error
    /// https://en.wikipedia.org/wiki/Mean_squared_error
    public let meanSquaredError: T
    /// F-statistic
    /// https://en.wikipedia.org/wiki/F-test
    public let fStat: T
    /// Probability in the f distribution
    public let fProbability: T
    
    public init(independentVariables x: Matrix<T>, dependentVariable y: Matrix<T>) throws {
        self.x = x
        self.y = y
        if x.rowCount != y.rowCount { throw MatrixError.mismatchedDimensions }
        let n = x.rowCount
        let p = x.columnCount
        df = n - p

        // There must be more than zero degrees of freedom.
        guard df > 0 else { throw RegressionError.insufficientData }

        let yColumn = y.column(0)

        // The beta coefficents
        beta = try Regression.beta(independentVariables: x, dependentVariable: y)
        residuals = try Regression.risiduals(beta: beta, independentVariables: x, dependentVariable: y)
        predicted = try x * beta

        // Sum of squares
        let mean = yColumn.reduce(0, +) / T(y.rowCount)
        modelSumOfSquares = sumOfSquares(x: predicted.column(0), mean: mean)
        totalSumOfSquares = sumOfSquares(x: yColumn, mean: mean)

        let residualsColumn = residuals.column(0)
        let meanError = residualsColumn.reduce(0, +) / T(residuals.rowCount)
        errorSumOfSquares = sumOfSquares(x: residualsColumn, mean: meanError)

        // R Squared
        rSquared = modelSumOfSquares/totalSumOfSquares

        // Mean squared error
        meanSquaredError = errorSumOfSquares / T(df)

        // Standard error
        stdError = sqrt(meanSquaredError)

        // F statistic
        fStat = (modelSumOfSquares / T(p - 1)) / meanSquaredError

        let v1 = p - 1
        let v2 = df
        fProbability = FDistribution.cumulativeProbability(of: fStat, n: v1, m: v2)

        // Adjusted R Squared
        let nAdj: T = T(n - 1) / T(n - p)
        let adjustment: T =  nAdj * (1 - rSquared)
        adjRSquared = 1 - adjustment

        // Standard error of the coefficients
        stdErrorOfCoeff = try ((meanSquaredError * x.gramian().inverse()).diagonal()).map(sqrt)

        // T statistic for the coefficients
        let tValues = try beta.column(0).asVector() * stdErrorOfCoeff.column(0).map { 1 / $0 }.asVector()
        tValuesOfCoeff = tValues.asComlumnMatrix()

        let pValues = tValues.value.map { TDistribution.cumulativeProbability(of: $0, n: v2) }

        pValuesOfCoeff = Matrix(columns: [pValues])
    }

    public func partialRegression(ofVariableAt index: Int) throws -> PartialRegression<T> {
        let variable = x.column(index).asVector().asComlumnMatrix()

        var others = x
        try others.remove(columnAt: index)

        let betaY = try Regression.beta(independentVariables: others, dependentVariable: y)
        let betaVariable = try Regression.beta(independentVariables: others, dependentVariable: variable)

        let residualsY = try Regression.risiduals(beta: betaY, independentVariables: others, dependentVariable: y)
        let residualsVariable = try Regression.risiduals(beta: betaVariable, independentVariables: others, dependentVariable: variable)

        return PartialRegression(residualsY: residualsY, residualsVar: residualsVariable)
    }

    public static func beta(independentVariables x: Matrix<T>, dependentVariable y: Matrix<T>) throws -> Matrix<T> {
        let ig = try x.gramian().inverse()
        let m = try x.moment(given: y)
        return try ig * m
    }
    
    public static func risiduals(beta: Matrix<T>, independentVariables x: Matrix<T>, dependentVariable y: Matrix<T>) throws -> Matrix<T> {
        var r: [[T]] = []
        for i in 0..<y.rowCount {
            let s = try y[i,0] - x.row(i) * beta.column(0)
            r.append([s])
        }
        return Matrix<T>(r)
    }
}

public struct PartialRegression<T: BinaryFloatingPoint> {
    public let residualsY: Matrix<T>
    public let residualsVar: Matrix<T>
}
