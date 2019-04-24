import Foundation

public struct Regression<T> where T: FloatingPoint {
    
    public let residuals: Matrix<T>
    public let beta: Matrix<T>
    /// Total sum of squares
    public let predicted: Matrix<T>
    /// Degrees of freedom
    public let df: Int
    /// Unbiased reduced chi squared
    public let rchi: T
    public let stdError: T
    public let rSquared: T
    
    public init(x: Matrix<T>, y: Matrix<T>) throws {
        if x.rowCount != y.rowCount { throw ComputationalError.mismatchedDimensions }
        let n = x.rowCount
        let p = x.columnCount
        df = n - p
        let yColumn = y.column(0)
        let mean = yColumn.reduce(0, +) / T(y.rowCount)
        beta = try Regression.beta(for: x, given: y)
        residuals = try Regression.risiduals(of: beta, for: x, given: y)
        predicted = try x * beta

        let rss: T = predicted.column(0).map({ square($0 - mean) }).reduce(0, +)
        let tss: T = y.column(0).map({ square($0 - mean) }).reduce(0, +)
        
        //If the total sum of squares is zero, there is no error
        
        rSquared = rss/tss
        rchi = try (residuals.column(0) * residuals.column(0)) / T(df)
        stdError = sqrt(rchi)
        
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
