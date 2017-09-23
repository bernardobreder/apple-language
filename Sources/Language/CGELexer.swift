//
//  Lexer.swift
//  codegenv
//
//  Created by Bernardo Breder on 27/11/16.
//  Copyright © 2016 Code Generator Environment. All rights reserved.
//

import Foundation

#if SWIFT_PACKAGE
    import Lexer
#endif

public enum CGETokenType: Int {
    
    case Identifier
    case Number, Symbol
    case String
    case ParensOpen
    case ParensClose
    case Comma, DotDot
    case Or, And, If, While, Repeat, For, Do, Def, Return, Up, Break, Continue, End
    case Plus, Minus, Mult, Div, Mod, Assign
    case Nil, True, False
    case Not, NotEqual, Equal, Lower, Greater, LowerEqual, GreaterEqual
    case Class, Extends, Function, Init
    case EOF
    
}

open class CGELexer: Lexer {
    
    public override init() {
        super.init()
        keyword("class", type: { _ in CGETokenType.Class.rawValue })
        keyword("init", type: { _ in CGETokenType.Init.rawValue })
        keyword("function", type: { _ in CGETokenType.Function.rawValue })
        keyword("false", type: { _ in CGETokenType.False.rawValue })
        keyword("do", type: { _ in CGETokenType.Do.rawValue })
        keyword("up", type: { _ in CGETokenType.Up.rawValue })
        keyword("or", type: { _ in CGETokenType.Or.rawValue })
        keyword("if", type: { _ in CGETokenType.If.rawValue })
        keyword("for", type: { _ in CGETokenType.For.rawValue })
        keyword("def", type: { _ in CGETokenType.Def.rawValue })
        keyword("nil", type: { _ in CGETokenType.Nil.rawValue })
        keyword("and", type: { _ in CGETokenType.And.rawValue })
        keyword("true", type: { _ in CGETokenType.True.rawValue })
        keyword("break", type: { _ in CGETokenType.Break.rawValue })
        keyword("while", type: { _ in CGETokenType.While.rawValue })
        keyword("repeat", type: { _ in CGETokenType.Repeat.rawValue })
        keyword("return", type: { _ in CGETokenType.Return.rawValue })
        keyword("continue", type: { _ in CGETokenType.Continue.rawValue })
        keyword("(", type: { _ in CGETokenType.ParensOpen.rawValue })
        keyword(")", type: { _ in CGETokenType.ParensClose.rawValue })
        keyword("!=", type: { _ in CGETokenType.NotEqual.rawValue })
        keyword("==", type: { _ in CGETokenType.Equal.rawValue })
        keyword("=", type: { _ in CGETokenType.Assign.rawValue })
        keyword("!=", type: { _ in CGETokenType.NotEqual.rawValue })
        keyword("<=", type: { _ in CGETokenType.LowerEqual.rawValue })
        keyword(">=", type: { _ in CGETokenType.GreaterEqual.rawValue })
        keyword("<", type: { _ in CGETokenType.Lower.rawValue })
        keyword(">", type: { _ in CGETokenType.Greater.rawValue })
        keyword(",", type: { _ in CGETokenType.Comma.rawValue })
        keyword("+", type: { _ in CGETokenType.Plus.rawValue })
        keyword("-", type: { _ in CGETokenType.Minus.rawValue })
        keyword("*", type: { _ in CGETokenType.Mult.rawValue })
        keyword("/", type: { _ in CGETokenType.Div.rawValue })
        keyword("!", type: { _ in CGETokenType.Not.rawValue })
        keyword(":", type: { _ in CGETokenType.DotDot.rawValue })
        keyword("%", type: { _ in CGETokenType.Mod.rawValue })
        identifier = { _ in CGETokenType.Identifier.rawValue }
        string = { _ in CGETokenType.String.rawValue }
        number = { _ in CGETokenType.Number.rawValue }
        symbol = { _ in CGETokenType.Symbol.rawValue }
    }
    
}
