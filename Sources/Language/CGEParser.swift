//
//  CGEParser.swift
//  codegenv
//
//  Created by Bernardo Breder on 27/11/16.
//  Copyright © 2016 Code Generator Environment. All rights reserved.
//

import Foundation

#if SWIFT_PACKAGE
    import Lexer
#endif

public enum CGEParserError: Error {
    case expectedNumberValue
    case expectedStringValue
    case expectedTrueValue
    case expectedFalseValue
    case expectedNilValue
    case expectedRepeatValue
    case expectedWhileValue
    case expectedIfValue
    case expectedUpValue
    case expectedReturnValue
    case expectedContinueValue
    case expectedBreakValue
    case expectedVariableValue
    case expectedDefineValue
    case expectedLiteralValue
    case expectedIdentifierValue
    case expectedDoubleValue
    case expectedElement
    case expectedClassId
    case expectedClassDefinition
    case expectedClassElement
    case expectedParamId
    case expectedEof
}

open class CGEParser {
    
    let tokens: [Token]
    
    var index: Int = 0
    
    public init(tokens: [Token]) {
        self.tokens = tokens
    }
    
    public func parseElement() throws -> CGEElementNode {
        switch try type() {
        case CGETokenType.Class.rawValue:
            return try parseClass()
        default:
            throw CGEParserError.expectedElement
        }
    }
    
    public func parseClass() throws -> CGEClassNode {
        next()
        
        if type() != CGETokenType.Identifier.rawValue {
            throw CGEParserError.expectedClassId
        }
        let id = self.word()!
        next()
        
        if type() != CGETokenType.Do.rawValue {
            throw CGEParserError.expectedClassId
        }
        next()
        
        while type() != CGETokenType.End.rawValue {
            try parseClassElement()
        }
        next()
        
        return CGEClassNode(id: id)
    }
    
    public func parseClassElement() throws -> CGEClassElementNode {
        switch try type() {
        case CGETokenType.Function.rawValue:
            return try parseClassFunction()
        case CGETokenType.Init.rawValue:
            return try parseClassInit()
        case CGETokenType.Init.rawValue:
            return try parseClassField()
        default:
            throw CGEParserError.expectedClassElement
        }
    }
    
    public func parseClassFunction() throws -> CGEClassElementNode {
        if type() != CGETokenType.Function.rawValue {
            throw CGEParserError.expectedClassId
        }
        next()
        
        if type() != CGETokenType.Identifier.rawValue {
            throw CGEParserError.expectedClassId
        }
        let id = self.word()!
        next()
        
        parseTypedParams()
    }
    
    public func parseTypedParams() throws -> CGEClassElementNode {
        
    }
    
    public func parseTypedParam() throws -> CGEClassElementNode {
        if type() != CGETokenType.Identifier.rawValue {
            throw CGEParserError.expectedParamId
        }
        let id = self.word()!
        next()
        
        if type() == CGETokenType.DotDot.rawValue {
            next()
            parseType()
        }
    }
    
    public func parseType() throws -> CGEClassElementNode {
        switch try type() {
        case CGETokenType.String.rawValue:
            return try parseClassFunction()
        case CGETokenType.Init.rawValue:
            return try parseClassInit()
        case CGETokenType.Init.rawValue:
            return try parseClassField()
        default:
            throw CGEParserError.expectedClassElement
        }
    }
    
    public func parseClassInit() throws -> CGEClassElementNode {
        if type() != CGETokenType.Init.rawValue {
            throw CGEParserError.expectedClassId
        }
    }
    
    public func parseClassField() throws -> CGEClassElementNode {
        
    }
    
    public func parseStatement() throws -> CGEValueNode {
        switch try type() {
        case CGETokenType.If.rawValue:
            return try parseIf()
        case CGETokenType.Def.rawValue:
            return try parseDefine()
        case CGETokenType.While.rawValue:
            return try parseWhile()
        case CGETokenType.Repeat.rawValue:
            return try parseRepeat()
        case CGETokenType.Return.rawValue:
            return try parseReturn()
        case CGETokenType.Break.rawValue:
            return try parseBreak()
        case CGETokenType.Continue.rawValue:
            return try parseContinue()
        case CGETokenType.Up.rawValue:
            return try parseUp()
        default:
            return try parseExpression()
        }
    }
    
    public func parseExpression() throws -> CGEValueNode {
        return try parseOr()
    }
    
    public func parseDefine() throws -> CGEValueNode {
        switch try type() {
        case CGETokenType.Def.rawValue:
            next()
            let variables: [CGEVariableValueNode] = try parseVariableArray()
            var values: [CGEValueNode] = []
            if case CGETokenType.Assign.rawValue = type() {
                next()
                values = try parseExpressionArray()
            }
            return CGEDefineValueNode(variables: variables, values: values)
        default: throw CGEParserError.expectedDefineValue
        }
    }
    
    public func parseVariable() throws -> CGEVariableValueNode {
        switch try type() {
        case CGETokenType.Identifier.rawValue:
            let word = self.word()!
            next()
            return CGEVariableValueNode(name: word)
        default: throw CGEParserError.expectedVariableValue
        }
    }
    
    public func parseVariableArray() throws -> [CGEVariableValueNode] {
        var array: [CGEVariableValueNode] = []
        array.append(try parseVariable())
        while case CGETokenType.Comma.rawValue = try type() {
            next()
            array.append(try parseVariable())
        }
        return array
    }
    
    public func parseExpressionArray() throws -> [CGEValueNode] {
        var values: [CGEValueNode] = []
        values.append(try parseExpression())
        while case CGETokenType.Comma.rawValue = try type() {
            next()
            values.append(try parseExpression())
        }
        return values
    }
    
    public func parseBreak() throws -> CGEValueNode {
        switch try type() {
        case CGETokenType.Break.rawValue:
            next()
            return CGEBreakValueNode()
        default:
            throw CGEParserError.expectedBreakValue
        }
    }
    
    public func parseContinue() throws -> CGEValueNode {
        switch try type() {
        case CGETokenType.Continue.rawValue:
            next()
            return CGEContinueValueNode()
        default:
            throw CGEParserError.expectedContinueValue
        }
    }
    
    public func parseReturn() throws -> CGEValueNode {
        switch try type() {
        case CGETokenType.Return.rawValue:
            next()
            return CGEReturnValueNode(try parseExpression())
        default:
            throw CGEParserError.expectedReturnValue
        }
    }
    
    public func parseUp() throws -> CGEValueNode {
        switch try type() {
        case CGETokenType.Up.rawValue:
            next()
            return CGEUpValueNode(try parseExpression())
        default:
            throw CGEParserError.expectedUpValue
        }
    }
    
    public func parseIf() throws -> CGEValueNode {
        switch try type() {
        case CGETokenType.If.rawValue:
            next()
            let condition = try parseExpression()
            let command = try parseExpression()
            return CGEIfValueNode(condition: condition, command: command)
        default:
            throw CGEParserError.expectedIfValue
        }
    }
    
    public func parseWhile() throws -> CGEValueNode {
        switch try type() {
        case CGETokenType.While.rawValue:
            next()
            let condition = try parseExpression()
            let command = try parseExpression()
            return CGEWhileValueNode(condition: condition, command: command)
        default:
            throw CGEParserError.expectedWhileValue
        }
    }
    
    public func parseRepeat() throws -> CGEValueNode {
        switch try type() {
        case CGETokenType.Repeat.rawValue:
            next()
            let command = try parseExpression()
            let condition = try parseExpression()
            return CGERepeatValueNode(condition: condition, command: command)
        default:
            throw CGEParserError.expectedRepeatValue
        }
    }
    
    public func parseOr() throws -> CGEValueNode {
        let left = try parseAnd()
        switch try type() {
        case CGETokenType.Or.rawValue:
            next()
            return CGEOrValueNode(left: left, right: try parseOr())
        default:
            return left
        }
    }
    
    public func parseAnd() throws -> CGEValueNode {
        let left = try parseCompare()
        switch try type() {
        case CGETokenType.And.rawValue:
            next()
            return CGEAndValueNode(left: left, right: try parseAnd())
        default:
            return left
        }
    }
    
    public func parseCompare() throws -> CGEValueNode {
        let left = try parseSum()
        switch try type() {
        case CGETokenType.Equal.rawValue:
            next()
            return CGEEqualValueNode(left: left, right: try parseCompare())
        case CGETokenType.NotEqual.rawValue:
            next()
            return CGENotEqualValueNode(left: left, right: try parseCompare())
        case CGETokenType.Lower.rawValue:
            next()
            return CGELowerValueNode(left: left, right: try parseCompare())
        case CGETokenType.Greater.rawValue:
            next()
            return CGEGreaterValueNode(left: left, right: try parseCompare())
        case CGETokenType.LowerEqual.rawValue:
            next()
            return CGELowerEqualValueNode(left: left, right: try parseCompare())
        case CGETokenType.GreaterEqual.rawValue:
            next()
            return CGEGreaterEqualValueNode(left: left, right: try parseCompare())
        default:
            return left
        }
    }
    
    public func parseSum() throws -> CGEValueNode {
        let left = try parseMul()
        switch try type() {
        case CGETokenType.Plus.rawValue:
            next()
            return CGEPlusValueNode(left: left, right: try parseSum())
        case CGETokenType.Minus.rawValue:
            next()
            return CGEMinusValueNode(left: left, right: try parseSum())
        default:
            return left
        }
    }
    
    public func parseMul() throws -> CGEValueNode {
        let left = try parseMod()
        switch try type() {
        case CGETokenType.Mult.rawValue:
            next()
            return CGEMultValueNode(left: left, right: try parseMul())
        case CGETokenType.Div.rawValue:
            next()
            return CGEDivValueNode(left: left, right: try parseMul())
        default:
            return left
        }
    }
    
    public func parseMod() throws -> CGEValueNode {
        let left = try parseUnary()
        switch try type() {
        case CGETokenType.Mod.rawValue:
            next()
            return CGEModValueNode(left: left, right: try parseMod())
        default:
            return left
        }
    }
    
    public func parseUnary() throws -> CGEValueNode {
        switch try type() {
        case CGETokenType.Not.rawValue:
            next()
            return CGENotValueNode(left: try parseLiteral())
        case CGETokenType.Minus.rawValue:
            next()
            return CGENegValueNode(left: try parseLiteral())
        default:
            return try parseLiteral()
        }
    }
    
    public func parseLiteral() throws -> CGEValueNode {
        switch try type() {
        case CGETokenType.ParensOpen.rawValue:
            next()
            let expr = try parseExpression()
            next()
            return expr
        case CGETokenType.Identifier.rawValue:
            return try parseIdentifier()
        case CGETokenType.True.rawValue:
            return try parseTrue()
        case CGETokenType.False.rawValue:
            return try parseFalse()
        case CGETokenType.String.rawValue:
            return try parseString()
        case CGETokenType.Nil.rawValue:
            return try parseNil()
        case CGETokenType.Number.rawValue:
            return try parseNumber()
        default:
            throw CGEParserError.expectedLiteralValue
        }
    }
    
    public func parseIdentifier() throws -> CGEValueNode {
        switch try type() {
        case CGETokenType.Identifier.rawValue:
            let word = self.word()!
            next()
            return CGEIdentifierValueNode(word)
        default:
            throw CGEParserError.expectedIdentifierValue
        }
    }
    
    public func parseNil() throws -> CGEValueNode {
        switch try type() {
        case CGETokenType.Nil.rawValue:
            next()
            return CGENilValueNode()
        default:
            throw CGEParserError.expectedNilValue
        }
    }
    
    public func parseNumber() throws -> CGEValueNode {
        switch try type() {
        case CGETokenType.Number.rawValue:
            let word = self.word()!
            guard let value = Double(word.word) else { throw CGEParserError.expectedDoubleValue }
            next()
            return CGENumberValueNode(value)
        default:
            throw CGEParserError.expectedNumberValue
        }
    }
    
    public func parseString() throws -> CGEValueNode {
        switch try type() {
        case CGETokenType.String.rawValue:
            let value = self.word()!.word
            next()
            return CGEStringValueNode(value)
        default:
            throw CGEParserError.expectedStringValue
        }
    }
    
    public func parseTrue() throws -> CGEValueNode {
        switch try type() {
        case CGETokenType.True.rawValue:
            next()
            return CGEBooleanValueNode(true)
        default:
            throw CGEParserError.expectedTrueValue
        }
    }
    
    public func parseFalse() throws -> CGEValueNode {
        switch try type() {
        case CGETokenType.False.rawValue:
            next()
            return CGEBooleanValueNode(false)
        default:
            throw CGEParserError.expectedFalseValue
        }
    }
    
    func type() throws -> Int {
        guard index >= 0 && index < tokens.count else { throw CGEParserError.expectedEof }
        return tokens[index].type
    }
    
    func id() throws -> Token {
        if try type() != CGETokenType.Identifier.rawValue {
            throw CGEParserError.expectedParamId
        }
        return try self.word()
    }
    
    func word() throws -> Token {
        guard index >= 0 && index < tokens.count else { throw CGEParserError.expectedEof }
        return tokens[index]
    }
    
    func next() {
        index = index + 1
    }
    
}
