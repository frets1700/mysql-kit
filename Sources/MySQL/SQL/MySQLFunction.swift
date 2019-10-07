/// MySQL specific `SQLFunction`.
public struct MySQLFunction: SQLFunction {
    /// See `SQLFunction`.
    public typealias Argument = GenericSQLFunctionArgument<MySQLExpression>
    
    /// See `SQLFunction`.
    public static func function(_ name: String, _ args: [Argument]) -> MySQLFunction {
        return .init(name: name, arguments: args)
    }
    
    /// See `SQLFunction`.
    public let name: String
    
    /// See `SQLFunction`.
    public let arguments: [Argument]
    
    /// See `SQLSerializable`.
    public func serialize(_ binds: inout [Encodable]) -> String {
        if name == "COUNT", arguments.count == 1, arguments[0].isExpression() == true {
            return name + "( DISTINCT " + arguments.map { $0.serialize(&binds) }.joined(separator: ", ") + ")"
        }
        return name + "(" + arguments.map { $0.serialize(&binds) }.joined(separator: ", ") + ")"
    }
}

extension SQLSelectExpression where Expression.Function == MySQLFunction {
    // custom
}
