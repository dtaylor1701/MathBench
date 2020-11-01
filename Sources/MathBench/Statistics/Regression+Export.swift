public extension Regression {
    func csvResult() -> String {
        var rows: [String] = []
        rows.append("Observation,Predicted,Actual")
        for i in 0..<y.rowCount {
            rows.append("\(i),\(predicted[i,0]),\(y[i,0])")
        }
        return rows.joined(separator: "\n")
    }

    func csvX() -> String {
        var rows: [String] = []
        let header = (0..<x.columnCount).map({ "Var \($0)" }).joined(separator: ",")
        rows.append(header)
        for i in 0..<x.rowCount {
            rows.append((0..<x.columnCount).map({ "\(x[i,$0])" }).joined(separator: ","))
        }
        return rows.joined(separator: "\n")
    }

    func csv() -> String {
        var rows: [String] = []
        var headers = (0..<x.columnCount).map({ "Var\($0)" })
        headers.append("Y")
        
        rows.append(headers.joined(separator: ","))
        for i in 0..<x.rowCount {
            var vals = (0..<x.columnCount).map({ "\(x[i,$0])" })
            vals.append("\(y[i,0])")
            rows.append(vals.joined(separator: ","))
        }
        return rows.joined(separator: "\n")
    }
}
