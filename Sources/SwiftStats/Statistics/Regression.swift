import Foundation

public struct Regression<T> where T: FloatingPoint {
    
    public let x: Matrix<T>
    public let y: Matrix<T>
    
    /// Residuals
    public let residuals: Matrix<T>
    /// Coeffecients
    public let beta: Matrix<T>
    /// Total sum of squares
    public let predicted: Matrix<T>
    /// Degrees of freedom
    public let df: Int
    /// Unbiased reduced chi squared
    public let rchi: T
    /// Standard Errpr
    public let stdError: T
    /// R Squared
    public let rSquared: T
    /// Adjusted R Squared
    public let adjRSquared: T
    /// Model Sum of Squares
    public let mss: T
    /// Total Sum of Suares
    public let tss: T
    public let varB: Matrix<T>
    /// Mean Squared Error
    public let mse: T
    
    public init(x: Matrix<T>, y: Matrix<T>) throws {
        self.x = x
        self.y = y
        if x.rowCount != y.rowCount { throw ComputationalError.mismatchedDimensions }
        let n = x.rowCount
        let p = x.columnCount
        df = n - p
        let yColumn = y.column(0)
        let mean = yColumn.reduce(0, +) / T(y.rowCount)
        beta = try Regression.beta(for: x, given: y)
        residuals = try Regression.risiduals(of: beta, for: x, given: y)
        predicted = try x * beta
        
        mss = predicted.column(0).map({ square($0 - mean) }).reduce(0, +)
        tss = y.column(0).map({ square($0 - mean) }).reduce(0, +)
        
        rSquared = mss/tss
        rchi = try (residuals.column(0) * residuals.column(0)) / T(df)
        stdError = sqrt(rchi)
        // Adjusted R Squared
        let nAdj: T = T(n - 1) / T(n - p)
        let adjustment: T =  nAdj * (1 - rSquared)
        adjRSquared = 1 - adjustment
        
        mse = (T(n - p) / T(n)) * rchi
        
        varB = try ((mse * x.gramian().inverse()).diagonal()).map(sqrt)
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


func square<T>(_ value: T) -> T where T: FloatingPoint {
    return value * value
}
