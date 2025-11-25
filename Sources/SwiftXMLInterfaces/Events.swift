//===--- Events.swift -----------------------------------------------------===//
//
// This source file is part of the SwiftXML.org open source project
//
// Copyright (c) 2021-2023 Stefan Springer (https://stefanspringer.com)
// and the SwiftXML project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
//===----------------------------------------------------------------------===//

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

public struct XEventHandlerError: LocalizedError {

    private let message: String

    public init(_ message: String) {
        self.message = message
    }

    public var errorDescription: String? {
        return message
    }
}

public protocol InternalEntityResolver {
    func resolve(entityWithName entityName: String, forAttributeWithName attributeName: String?, atElementWithName elementName: String?) -> String?
}

public enum WhitespaceIndicator {
    case WHITESPACE
    case NOT_WHITESPACE
    case UNKNOWN
    
    static public func +(left: WhitespaceIndicator, right: WhitespaceIndicator) -> WhitespaceIndicator {
        if left == .NOT_WHITESPACE || right == .NOT_WHITESPACE {
            return .NOT_WHITESPACE
        } else if left == .UNKNOWN || right == .UNKNOWN {
            return .UNKNOWN
        } else {
            return .WHITESPACE
        }
    }
}

public struct XTextRange: CustomStringConvertible {
    
    public let startLine: Int
    public let startColumn: Int
    public let endLine: Int
    public let endColumn: Int
    
    public init(
        startLine: Int,
        startColumn: Int,
        endLine: Int,
        endColumn: Int
    ) {
        self.startLine = startLine
        self.startColumn = startColumn
        self.endLine = endLine
        self.endColumn = endColumn
    }
    
    public var description: String { get { "\(startLine):\(startColumn) - \(endLine):\(endColumn)" } }
}

public struct XDataRange: CustomStringConvertible {
    
    public let binaryStart: Int
    public let binaryUntil: Int
    
    public init(
        binaryStart: Int,
        binaryUntil: Int
    ) {
        self.binaryStart = binaryStart
        self.binaryUntil = binaryUntil
    }
    
    public var description: String { get { "\(binaryStart)..<\(binaryUntil)" } }
}

public enum ImmediateTextHandlingNearEntities {
    case always; case atExternalEntities; case atInternalEntities; case never
}

/// If any of the handler methods return `false`, then the processing is aborted.
public protocol XEventHandler {
    
    func documentStart() -> Bool
    
    func xmlDeclaration(version: String, encoding: String?, standalone: String?, textRange: XTextRange?, dataRange: XDataRange?) -> Bool

    func documentTypeDeclarationStart(name: String, publicID: String?, systemID: String?, textRange: XTextRange?, dataRange: XDataRange?) -> Bool
    
    func documentTypeDeclarationEnd(textRange: XTextRange?, dataRange: XDataRange?) -> Bool

    func elementStart(name: String, attributes: inout [String:String], textRange: XTextRange?, dataRange: XDataRange?) -> Bool

    func elementEnd(name: String, textRange: XTextRange?, dataRange: XDataRange?) -> Bool
    
    func enterExternalDataSource(data: Data, entityName: String?, systemID: String, url: URL?, textRange: XTextRange?, dataRange: XDataRange?) -> Bool
    
    func enterInternalDataSource(data: Data, entityName: String, textRange: XTextRange?, dataRange: XDataRange?) -> Bool

    func text(text: String, whitespace: WhitespaceIndicator, textRange: XTextRange?, dataRange: XDataRange?) -> Bool

    func cdataSection(text: String, textRange: XTextRange?, dataRange: XDataRange?) -> Bool

    func processingInstruction(target: String, data: String?, textRange: XTextRange?, dataRange: XDataRange?) -> Bool

    func comment(text: String, textRange: XTextRange?, dataRange: XDataRange?) -> Bool

    func internalEntityDeclaration(name: String, value: String, textRange: XTextRange?, dataRange: XDataRange?) -> Bool

    func externalEntityDeclaration(name: String, publicID:  String?, systemID: String, textRange: XTextRange?, dataRange: XDataRange?) -> Bool
    
    func leaveExternalDataSource() -> Bool
    
    func leaveInternalDataSource() -> Bool

    func unparsedEntityDeclaration(name: String, publicID:  String?, systemID: String, notation: String, textRange: XTextRange?, dataRange: XDataRange?) -> Bool

    func notationDeclaration(name: String, publicID:  String?, systemID: String?, textRange: XTextRange?, dataRange: XDataRange?) -> Bool

    func internalEntity(name: String, textRange: XTextRange?, dataRange: XDataRange?) -> Bool

    func externalEntity(name: String, textRange: XTextRange?, dataRange: XDataRange?) -> Bool

    func elementDeclaration(name: String, literal: String, textRange: XTextRange?, dataRange: XDataRange?) -> Bool

    func attributeListDeclaration(name: String, literal: String, textRange: XTextRange?, dataRange: XDataRange?) -> Bool

    func parameterEntityDeclaration(name: String, value: String, textRange: XTextRange?, dataRange: XDataRange?) -> Bool

    func documentEnd() -> Bool
}

open class XDefaultEventHandler: XEventHandler {

    public init() {}
    
    open func documentStart() -> Bool { true }

    open func xmlDeclaration(version: String, encoding: String?, standalone: String?, textRange: XTextRange?, dataRange: XDataRange?)-> Bool { true }
    
    open func documentTypeDeclarationStart(name: String, publicID: String?, systemID: String?, textRange: XTextRange?, dataRange: XDataRange?)-> Bool { true }
    
    open func documentTypeDeclarationEnd(textRange: XTextRange?, dataRange: XDataRange?)-> Bool { true }

    open func elementStart(name: String, attributes: inout [String:String], textRange: XTextRange?, dataRange: XDataRange?)-> Bool { true }

    open func elementEnd(name: String, textRange: XTextRange?, dataRange: XDataRange?)-> Bool { true }
    
    open func enterExternalDataSource(data: Data, entityName: String?, systemID: String, url: URL?, textRange: XTextRange?, dataRange: XDataRange?)-> Bool { true }
    
    open func enterInternalDataSource(data: Data, entityName: String, textRange: XTextRange?, dataRange: XDataRange?)-> Bool { true }

    open func text(text: String, whitespace: WhitespaceIndicator, textRange: XTextRange?, dataRange: XDataRange?)-> Bool { true }

    open func cdataSection(text: String, textRange: XTextRange?, dataRange: XDataRange?)-> Bool { true }

    open func processingInstruction(target: String, data: String?, textRange: XTextRange?, dataRange: XDataRange?)-> Bool { true }

    open func comment(text: String, textRange: XTextRange?, dataRange: XDataRange?)-> Bool { true }

    open func internalEntityDeclaration(name: String, value: String, textRange: XTextRange?, dataRange: XDataRange?)-> Bool { true }

    open func externalEntityDeclaration(name: String, publicID:  String?, systemID: String, textRange: XTextRange?, dataRange: XDataRange?)-> Bool { true }
    
    open func leaveExternalDataSource() -> Bool { true }
    
    open func leaveInternalDataSource() -> Bool { true }

    open func unparsedEntityDeclaration(name: String, publicID:  String?, systemID: String, notation: String, textRange: XTextRange?, dataRange: XDataRange?)-> Bool { true }

    open func notationDeclaration(name: String, publicID:  String?, systemID: String?, textRange: XTextRange?, dataRange: XDataRange?)-> Bool { true }

    open func internalEntity(name: String, textRange: XTextRange?, dataRange: XDataRange?)-> Bool { true }

    open func externalEntity(name: String, textRange: XTextRange?, dataRange: XDataRange?)-> Bool { true }

    open func elementDeclaration(name: String, literal: String, textRange: XTextRange?, dataRange: XDataRange?)-> Bool { true }

    open func attributeListDeclaration(name: String, literal: String, textRange: XTextRange?, dataRange: XDataRange?)-> Bool { true }

    open func parameterEntityDeclaration(name: String, value: String, textRange: XTextRange?, dataRange: XDataRange?)-> Bool { true }

    open func documentEnd() -> Bool { true }
}
