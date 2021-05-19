//
//  SubjectFormat.swift
//  Dcpmaker
//
//  Created by Giantwow on 13/05/2021.
//

import Foundation

public struct SubjectFormat: Codable {
    
    enum ParameterType: String, Codable {
        case bool = "bool"
        case int = "int"
        case float = "float"
        case string = "string"
        
        case array_bool = "array_bool"
        case array_int = "array_int"
        case array_float = "array_float"
        case array_string = "array_string"
        
        case matrix_bool = "matrix_bool"
        case matrix_int = "matrix_int"
        case matrix_float = "matrix_float"
        case matrix_string = "matrix_string"
    }
    
    enum ValuedParameter: Codable {
        
        case bool(value: Bool)
        case int(value: Int)
        case float(value: Float)
        case string(value: String)
        
        case array_bool(value: [Bool])
        case array_int(value: [Int])
        case array_float(value: [Float])
        case array_string(value: [String])
        
        case matrix_bool(value: [[Bool]])
        case matrix_int(value: [[Int]])
        case matrix_float(value: [[Float]])
        case matrix_string(value: [[String]])
        
        enum CodingKeys: String, CodingKey {
            case type = "type"
            case value = "value"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: Self.CodingKeys.self)
            let type = try values.decode(String.self, forKey: .type)
            switch ParameterType(rawValue: type) {
                case .bool:
                    self = .bool(value: try values.decode(Bool.self, forKey: .value))
                case .int:
                    self = .int(value: try values.decode(Int.self, forKey: .value))
                case .float:
                    self = .float(value: try values.decode(Float.self, forKey: .value))
                case .string:
                    self = .string(value: try values.decode(String.self, forKey: .value))
                    
                case .array_bool:
                    self = .array_bool(value: try values.decode([Bool].self, forKey: .value))
                case .array_int:
                    self = .array_int(value: try values.decode([Int].self, forKey: .value))
                case .array_float:
                    self = .array_float(value: try values.decode([Float].self, forKey: .value))
                case .array_string:
                    self = .array_string(value: try values.decode([String].self, forKey: .value))

                case .matrix_bool:
                    self = .matrix_bool(value: try values.decode([[Bool]].self, forKey: .value))
                case .matrix_int:
                    self = .matrix_int(value: try values.decode([[Int]].self, forKey: .value))
                case .matrix_float:
                    self = .matrix_float(value: try values.decode([[Float]].self, forKey: .value))
                case .matrix_string:
                    self = .matrix_string(value: try values.decode([[String]].self, forKey: .value))

                case nil:
                    throw "unknown type \(type)"
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: Self.CodingKeys.self)
            switch self {
                case .bool(value: let value):
                    try container.encode("bool", forKey: .type)
                    try container.encode(value, forKey: .value)
                case .int(value: let value):
                    try container.encode("int", forKey: .type)
                    try container.encode(value, forKey: .value)
                case .float(value: let value):
                    try container.encode("float", forKey: .type)
                    try container.encode(value, forKey: .value)
                case .string(value: let value):
                    try container.encode("string", forKey: .type)
                    try container.encode(value, forKey: .value)
                    
                case .array_bool(value: let value):
                    try container.encode("array_bool", forKey: .type)
                    try container.encode(value, forKey: .value)
                case .array_int(value: let value):
                    try container.encode("array_int", forKey: .type)
                    try container.encode(value, forKey: .value)
                case .array_float(value: let value):
                    try container.encode("array_float", forKey: .type)
                    try container.encode(value, forKey: .value)
                case .array_string(value: let value):
                    try container.encode("array_string", forKey: .type)
                    try container.encode(value, forKey: .value)

                case .matrix_bool(value: let value):
                    try container.encode("matrix_bool", forKey: .type)
                    try container.encode(value, forKey: .value)
                case .matrix_int(value: let value):
                    try container.encode("matrix_int", forKey: .type)
                    try container.encode(value, forKey: .value)
                case .matrix_float(value: let value):
                    try container.encode("matrix_float", forKey: .type)
                    try container.encode(value, forKey: .value)
                case .matrix_string(value: let value):
                    try container.encode("matrix_string", forKey: .type)
                    try container.encode(value, forKey: .value)
            }
        }
        
        var type: ParameterType {
            switch self {
                case .bool:
                    return .bool
                case .int:
                    return .int
                case .float:
                    return .float
                case .string:
                    return .string
                case .array_bool:
                    return .array_bool
                case .array_int:
                    return .array_int
                case .array_float:
                    return .array_float
                case .array_string:
                    return .array_string
                case .matrix_bool:
                    return .matrix_bool
                case .matrix_int:
                    return .matrix_int
                case .matrix_float:
                    return .matrix_float
                case .matrix_string:
                    return .matrix_string
            }
        }
        
    }
    
    public struct TypedParameter: Codable {
        var type: ParameterType
        var name: String
    }
    
    public struct Function: Codable {
        var name: String
        var parameters: [TypedParameter]
        var returnType: ParameterType
    }
    
    public struct Test: Codable {
        var name: String
        var parameters: [ValuedParameter]
        var expectedReturn: ValuedParameter
        var expectedOutput: String
    }
    
    public var function: Function
    
    public var tests: [Test]
    
}
