//
//  CGParserTests.swift
//  Language
//
//  Created by Bernardo Breder on 31/12/16.
//
//

import XCTest
import Foundation
@testable import Language

class CGParserTests: XCTestCase {

    func testExample() throws {
        XCTAssertEqual(1, try valueAsDouble("1"))
        XCTAssertEqual(-1, try valueAsDouble("-1"))
        XCTAssertEqual(-123, try valueAsDouble("-123"))
        XCTAssertEqual("aa", try valueAsString("\"aa\""))
        XCTAssertEqual(true, try valueAsBool("true"))
        XCTAssertEqual(false, try valueAsBool("false"))
        XCTAssertNil(try value("nil"))
        XCTAssertNil(try value("a"))
        XCTAssertEqual(3, try valueAsDouble("1 + 2"))
        XCTAssertEqual("ab", try valueAsString("\"a\" + \"b\""))
        XCTAssertEqual(-1, try valueAsDouble("1 - 2"))
        XCTAssertEqual(6, try valueAsDouble("2 * 3"))
        XCTAssertEqual(0.5, try valueAsDouble("1 / 2"))
        XCTAssertEqual(7, try valueAsDouble("1 + 2 * 3"))
        XCTAssertEqual(4, try valueAsDouble("4 % 6"))
        XCTAssertEqual(2, try valueAsDouble("6 % 4"))
        XCTAssertEqual(3, try valueAsDouble("1 + 2"))
        XCTAssertEqual(false, try valueAsBool("!true"))
        XCTAssertEqual(true, try valueAsBool("!false"))
        XCTAssertEqual(9, try valueAsDouble("(1+2)*3"))
        XCTAssertEqual(true, try valueAsBool("true or true"))
        XCTAssertEqual(true, try valueAsBool("true or false"))
        XCTAssertEqual(true, try valueAsBool("false or true"))
        XCTAssertEqual(false, try valueAsBool("false or false"))
        XCTAssertEqual(true, try valueAsBool("true and true"))
        XCTAssertEqual(false, try valueAsBool("true and false"))
        XCTAssertEqual(false, try valueAsBool("false and true"))
        XCTAssertEqual(false, try valueAsBool("false and false"))
        XCTAssertEqual(true, try valueAsBool("1 == 1"))
        XCTAssertEqual(false, try valueAsBool("1 == 2"))
        XCTAssertEqual(false, try valueAsBool("1 != 1"))
        XCTAssertEqual(true, try valueAsBool("1 != 2"))
        XCTAssertEqual(false, try valueAsBool("1 > 1"))
        XCTAssertEqual(false, try valueAsBool("1 > 2"))
        XCTAssertEqual(false, try valueAsBool("1 < 1"))
        XCTAssertEqual(true, try valueAsBool("1 < 2"))
        XCTAssertEqual(true, try valueAsBool("1 >= 1"))
        XCTAssertEqual(false, try valueAsBool("1 >= 2"))
        XCTAssertEqual(true, try valueAsBool("1 <= 1"))
        XCTAssertEqual(true, try valueAsBool("1 <= 2"))
        try stmt("if true false")
        try stmt("while false 1")
        try stmt("repeat 1 false")
        try stmt("break")
        try stmt("continue")
        try stmt("return true")
        try stmt("up true")
        try stmt("if a == 1 1")
    }
    
    func stmt(_ input: String) throws {
        let tokens = try CGELexer().lex(input: input)
        let _ = try CGEParser(tokens: tokens).parseStatement().value(CGEContext())
    }
    
    func value(_ input: String) throws -> Any? {
        let tokens = try CGELexer().lex(input: input)
        return try CGEParser(tokens: tokens).parseExpression().value(CGEContext())
    }
    
    func valueAsBool(_ input: String) throws -> Bool? {
        return try value(input) as? Bool
    }
    
    func valueAsDouble(_ input: String) throws -> Double? {
        return try value(input) as? Double
    }
    
    func valueAsString(_ input: String) throws -> String? {
        return try value(input) as? String
    }

}
