//
//  LanguageTests.swift
//  Language
//
//  Created by Bernardo Breder.
//
//

import XCTest
@testable import LanguageTests

extension CGParserTests {

	static var allTests : [(String, (CGParserTests) -> () throws -> Void)] {
		return [
			("testExample", testExample),
		]
	}

}

extension CGLexerTests {

	static var allTests : [(String, (CGLexerTests) -> () throws -> Void)] {
		return [
			("testLexer", testLexer),
		]
	}

}

XCTMain([
	testCase(CGParserTests.allTests),
	testCase(CGLexerTests.allTests),
])

