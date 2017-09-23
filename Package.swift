//
//  Package.swift
//  Language
//
//

import PackageDescription

let package = Package(
	name: "Language",
	targets: [
		Target(name: "Language", dependencies: ["Lexer", "StringBuffer"]),
		Target(name: "Lexer", dependencies: []),
		Target(name: "StringBuffer", dependencies: []),
	]
)

