import Foundation

extension Matrix where T: FloatingPoint {
    func det(given decomposition: LUDecomposition<T>?) -> T? {
        guard let lu = (decomposition ?? LUDecomposition(self)), isSquare else { return nil }
        var r: T = 1
        for i in 0..<rowLength {
            r *= lu.upper[i,i]
        }
        let sign: T = lu.exchanges.isMultiple(of: 2) ? 1 : -1
        return r * sign
    }
}
