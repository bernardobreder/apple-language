//
//  CGENode.swift
//  codegenv
//
//  Created by Bernardo Breder on 27/11/16.
//  Copyright © 2016 Code Generator Environment. All rights reserved.
//

import Foundation

#if SWIFT_PACKAGE
    import StringBuffer
    import Lexer
#endif

open class CGEContext {
    
    public init() {
    }
    
}

open class CGESwiftContext: CGEContext {
    
    public private(set) var tabCount = 0
    
    public override init() {
    }
    
    @discardableResult
    public func incTab() ->Self{
        self.tabCount += 1;
        return self
    }
    
    @discardableResult
    public func decTab() ->Self{
        self.tabCount -= 1;
        return self
    }
    
}

open class CGENode {
    
    public func value(_ context: CGEContext) -> Any? {
        return nil
    }
    
    public func swift(_ context: CGESwiftContext) -> String {
        return ""
    }
    
}

open class CGEElementNode: CGENode {
    
}

open class CGEClassNode: CGEElementNode {
    
    let id: Token
    
    public init(id: Token) {
        self.id = id
    }
    
    public override func value(_ context: CGEContext) -> Any? {
        return nil
    }
    
    public override func swift(_ context: CGESwiftContext) -> String {
        return ""
    }
    
}

open class CGEClassElementNode: CGENode {
    
}

open class CGEClassFunctionNode: CGEClassElementNode {
    
}

open class CGEClassInitNode: CGEClassElementNode {
    
}

open class CGEClassFieldNode: CGEClassElementNode {
    
}

open class CGEValueNode: CGENode {
    
}

open class CGEBlockValueNode: CGEValueNode {
    
    let values: [CGEValueNode]
    
    public init(values: [CGEValueNode]) {
        self.values = values
    }
    
    public override func value(_ context: CGEContext) -> Any? {
        for value in values {
            if let value = value.value(context) {
                return value
            }
        }
        return nil
    }
    
    public override func swift(_ context: CGESwiftContext) -> String {
        let buffer = StringBuffer()
        buffer.incTab(count: context.tabCount).write("do {").line()
        context.incTab()
        values.forEach({value in buffer.write(value.swift(context)) })
        context.decTab()
        buffer.incTab(count: context.tabCount).write("}")
        return buffer.string
    }
    
}

open class CGEVariableValueNode: CGEValueNode {
    
    let name: Token
    
    public init(name: Token) {
        self.name = name
    }
    
    public override func swift(_ context: CGESwiftContext) -> String {
        return name.word
    }
    
}

open class CGEDefineValueNode: CGEValueNode {
    
    let variables: [CGEVariableValueNode]
    
    let values: [CGEValueNode]
    
    public init(variables: [CGEVariableValueNode], values: [CGEValueNode]) {
        self.variables = variables
        self.values = values
    }
    
    public override func value(_ context: CGEContext) -> Any? {
        return nil
    }
    
}

open class CGEIfValueNode: CGEValueNode {
    
    let condition: CGEValueNode
    
    let command: CGEValueNode
    
    public init(condition: CGEValueNode, command: CGEValueNode) {
        self.condition = condition
        self.command = command
    }
    
    public override func value(_ context: CGEContext) -> Any? {
        if condition.value(context) as? Bool == true {
            return command.value(context)
        }
        return nil
    }
    
}

open class CGEWhileValueNode: CGEValueNode {
    
    let condition: CGEValueNode
    
    let command: CGEValueNode
    
    public init(condition: CGEValueNode, command: CGEValueNode) {
        self.condition = condition
        self.command = command
    }
    
    public override func value(_ context: CGEContext) -> Any? {
        while condition.value(context) as? Bool == true {
            if let result = command.value(context) {
                return result
            }
        }
        return nil
    }
    
}

open class CGERepeatValueNode: CGEValueNode {
    
    let condition: CGEValueNode
    
    let command: CGEValueNode
    
    public init(condition: CGEValueNode, command: CGEValueNode) {
        self.condition = condition
        self.command = command
    }
    
    public override func value(_ context: CGEContext) -> Any? {
        repeat {
            if let result = command.value(context) {
                return result
            }
        } while condition.value(context) as? Bool == true
        return nil
    }
    
}

open class CGEBreakValueNode: CGEValueNode {
    
    public override func value(_ context: CGEContext) -> Any? {
        return nil
    }
    
}

open class CGEContinueValueNode: CGEValueNode {
    
    public override func value(_ context: CGEContext) -> Any? {
        return nil
    }
    
}

open class CGEReturnValueNode: CGEValueNode {
    
    let value: CGEValueNode
    
    public init(_ value: CGEValueNode) {
        self.value = value
    }
    
    public override func value(_ context: CGEContext) -> Any? {
        return nil
    }
    
}

open class CGEUpValueNode: CGEValueNode {
    
    let value: CGEValueNode
    
    public init(_ value: CGEValueNode) {
        self.value = value
    }
    
    public override func value(_ context: CGEContext) -> Any? {
        return nil
    }
    
}

open class CGEOrValueNode: CGEValueNode {
    
    let left: CGEValueNode
    
    let right: CGEValueNode
    
    public init(left: CGEValueNode, right: CGEValueNode) {
        self.left = left
        self.right = right
    }
    
    public override func value(_ context: CGEContext) -> Any? {
        let l = left.value(context)
        let r = right.value(context)
        if let lb = l as? Bool {
            if let rb = r as? Bool {
                return lb || rb
            }
        }
        return nil
    }
    
}

open class CGEAndValueNode: CGEValueNode {
    
    let left: CGEValueNode
    
    let right: CGEValueNode
    
    public init(left: CGEValueNode, right: CGEValueNode) {
        self.left = left
        self.right = right
    }
    
    public override func value(_ context: CGEContext) -> Any? {
        let l = left.value(context)
        let r = right.value(context)
        if let lb = l as? Bool {
            if let rb = r as? Bool {
                return lb && rb
            }
        }
        return nil
    }
    
}

open class CGEEqualValueNode: CGEValueNode {
    
    let left: CGEValueNode
    
    let right: CGEValueNode
    
    public init(left: CGEValueNode, right: CGEValueNode) {
        self.left = left
        self.right = right
    }
    
    public override func value(_ context: CGEContext) -> Any? {
        let l = left.value(context)
        let r = right.value(context)
        if let lo = l as? NSObject {
            if let ro = r as? NSObject {
                return lo == ro
            }
        } else if let ln = l as? Double {
            if let rn = r as? Double {
                return ln == rn
            }
        } else if let ls = l as? String {
            if let rs = r as? String {
                return ls == rs
            }
        } else if let lb = l as? Bool {
            if let rb = r as? Bool {
                return lb == rb
            }
        }
        return nil
    }
    
}

open class CGENotEqualValueNode: CGEValueNode {
    
    let left: CGEValueNode
    
    let right: CGEValueNode
    
    public init(left: CGEValueNode, right: CGEValueNode) {
        self.left = left
        self.right = right
    }
    
    public override func value(_ context: CGEContext) -> Any? {
        let l = left.value(context)
        let r = right.value(context)
        if let lo = l as? NSObject {
            if let ro = r as? NSObject {
                return lo != ro
            }
        } else if let ln = l as? Double {
            if let rn = r as? Double {
                return ln != rn
            }
        } else if let ls = l as? String {
            if let rs = r as? String {
                return ls != rs
            }
        } else if let lb = l as? Bool {
            if let rb = r as? Bool {
                return lb != rb
            }
        }
        return nil
    }
    
}

open class CGELowerValueNode: CGEValueNode {
    
    let left: CGEValueNode
    
    let right: CGEValueNode
    
    public init(left: CGEValueNode, right: CGEValueNode) {
        self.left = left
        self.right = right
    }
    
    public override func value(_ context: CGEContext) -> Any? {
        let l = left.value(context)
        let r = right.value(context)
        if let ln = l as? Double {
            if let rn = r as? Double {
                return ln < rn
            }
        } else if let ln = l as? Double {
            if let rn = r as? Double {
                return ln < rn
            }
        } else if let ls = l as? String {
            if let rs = r as? String {
                return ls < rs
            }
        }
        return nil
    }
    
}

open class CGEGreaterValueNode: CGEValueNode {
    
    let left: CGEValueNode
    
    let right: CGEValueNode
    
    public init(left: CGEValueNode, right: CGEValueNode) {
        self.left = left
        self.right = right
    }
    
    public override func value(_ context: CGEContext) -> Any? {
        let l = left.value(context)
        let r = right.value(context)
        if let ln = l as? Double {
            if let rn = r as? Double {
                return ln > rn
            }
        } else if let ln = l as? Double {
            if let rn = r as? Double {
                return ln > rn
            }
        } else if let ls = l as? String {
            if let rs = r as? String {
                return ls > rs
            }
        }
        return nil
    }
    
}

open class CGELowerEqualValueNode: CGEValueNode {
    
    let left: CGEValueNode
    
    let right: CGEValueNode
    
    public init(left: CGEValueNode, right: CGEValueNode) {
        self.left = left
        self.right = right
    }
    
    public override func value(_ context: CGEContext) -> Any? {
        let l = left.value(context)
        let r = right.value(context)
        if let ln = l as? Double {
            if let rn = r as? Double {
                return ln <= rn
            }
        } else if let ln = l as? Double {
            if let rn = r as? Double {
                return ln <= rn
            }
        } else if let ls = l as? String {
            if let rs = r as? String {
                return ls <= rs
            }
        }
        return nil
    }
    
}

open class CGEGreaterEqualValueNode: CGEValueNode {
    
    let left: CGEValueNode
    
    let right: CGEValueNode
    
    public init(left: CGEValueNode, right: CGEValueNode) {
        self.left = left
        self.right = right
    }
    
    public override func value(_ context: CGEContext) -> Any? {
        let l = left.value(context)
        let r = right.value(context)
        if let ln = l as? Double {
            if let rn = r as? Double {
                return ln >= rn
            }
        } else if let ln = l as? Double {
            if let rn = r as? Double {
                return ln >= rn
            }
        } else if let ls = l as? String {
            if let rs = r as? String {
                return ls >= rs
            }
        }
        return nil
    }
    
}

open class CGEPlusValueNode: CGEValueNode {
    
    let left: CGEValueNode
    
    let right: CGEValueNode
    
    public init(left: CGEValueNode, right: CGEValueNode) {
        self.left = left
        self.right = right
    }
    
    public override func value(_ context: CGEContext) -> Any? {
        let l = left.value(context)
        let r = right.value(context)
        if let ln = l as? Double {
            if let rn = r as? Double {
                return ln + rn
            } else {
                return ln
            }
        } else if let ls = l as? String {
            if let rs = r as? String {
                return ls + rs
            } else {
                return ls
            }
        }
        return nil
    }
    
}

open class CGEMinusValueNode: CGEValueNode {
    
    let left: CGEValueNode
    
    let right: CGEValueNode
    
    public init(left: CGEValueNode, right: CGEValueNode) {
        self.left = left
        self.right = right
    }
    
    public override func value(_ context: CGEContext) -> Any? {
        let l = left.value(context)
        let r = right.value(context)
        if let ln = l as? Double {
            if let rn = r as? Double {
                return ln - rn
            } else {
                return ln
            }
        }
        return nil
    }
    
}

open class CGEMultValueNode: CGEValueNode {
    
    let left: CGEValueNode
    
    let right: CGEValueNode
    
    public init(left: CGEValueNode, right: CGEValueNode) {
        self.left = left
        self.right = right
    }
    
    public override func value(_ context: CGEContext) -> Any? {
        let l = left.value(context)
        let r = right.value(context)
        if let ln = l as? Double {
            if let rn = r as? Double {
                return ln * rn
            } else {
                return ln
            }
        }
        return nil
    }
    
}

open class CGEDivValueNode: CGEValueNode {
    
    let left: CGEValueNode
    
    let right: CGEValueNode
    
    public init(left: CGEValueNode, right: CGEValueNode) {
        self.left = left
        self.right = right
    }
    
    public override func value(_ context: CGEContext) -> Any? {
        let l = left.value(context)
        let r = right.value(context)
        if let ln = l as? Double {
            if let rn = r as? Double {
                return ln / rn
            } else {
                return ln
            }
        }
        return nil
    }
    
}

open class CGEModValueNode: CGEValueNode {
    
    let left: CGEValueNode
    
    let right: CGEValueNode
    
    public init(left: CGEValueNode, right: CGEValueNode) {
        self.left = left
        self.right = right
    }
    
    public override func value(_ context: CGEContext) -> Any? {
        let l = left.value(context)
        let r = right.value(context)
        if let ln = l as? Double {
            if let rn = r as? Double {
                return Double(Int(ln) % Int(rn))
            } else {
                return ln
            }
        }
        return nil
    }
    
}

open class CGENotValueNode: CGEValueNode {
    
    let left: CGEValueNode
    
    public init(left: CGEValueNode) {
        self.left = left
    }
    
    public override func value(_ context: CGEContext) -> Any? {
        let l = left.value(context)
        if let lb = l as? Bool {
            return !lb
        }
        return nil
    }
    
}

open class CGENegValueNode: CGEValueNode {
    
    let left: CGEValueNode
    
    public init(left: CGEValueNode) {
        self.left = left
    }
    
    public override func value(_ context: CGEContext) -> Any? {
        let l = left.value(context)
        if let ld = l as? Double {
            return -ld
        }
        return nil
    }
    
}

open class CGENumberValueNode: CGEValueNode {
    
    let value: Double
    
    public init(_ value: Double) {
        self.value = value
    }
    
    public override func value(_ context: CGEContext) -> Any? {
        return value
    }
    
}

open class CGEStringValueNode: CGEValueNode {
    
    let value: String
    
    public init(_ value: String) {
        self.value = value
    }
    
    public override func value(_ context: CGEContext) -> Any? {
        return value
    }
    
}

open class CGEBooleanValueNode: CGEValueNode {
    
    let value: Bool
    
    public init(_ value: Bool) {
        self.value = value
    }
    
    public override func value(_ context: CGEContext) -> Any? {
        return value
    }
    
}

open class CGENilValueNode: CGEValueNode {
    
    public override func value(_ context: CGEContext) -> Any? {
        return nil
    }
    
}

open class CGEIdentifierValueNode: CGEValueNode {
    
    let value: Token
    
    public init(_ value: Token) {
        self.value = value
    }
    
    public override func value(_ context: CGEContext) -> Any? {
        return nil
    }
    
}
