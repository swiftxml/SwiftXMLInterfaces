//===--- Parser.swift -----------------------------------------------------===//
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

public protocol Parser {
    func parse(
        fromData: Data,
        sourceInfo: String?,
        eventHandlers: [XEventHandler],
        immediateTextHandlingNearEntities: ImmediateTextHandlingNearEntities
    ) throws
}

public enum XDocumentSource {
    
    case url(_: URL)
    case path(_: String)
    case text(_: String)
    case data(_: Data)
    
    public func getData() throws -> Data {
        switch self {
        case .url(let url):
            try Data(contentsOf: url/*, options: [.alwaysMapped]*/)
        case .path(let path):
            try Data(contentsOf: URL(fileURLWithPath: path)/*, options: [.alwaysMapped]*/)
        case .text(let text):
            if let data = text.data(using: .utf8) {
                data
            } else {
                throw ParseError("could not decode assumed UTF-8 text")
            }
        case .data(let data):
            data
        }
    }
}

public class ConvenienceParser {
    
    let parser: Parser
    let mainEventHandler: XEventHandler
    
    public init(parser: Parser, mainEventHandler: XEventHandler) {
        self.parser = parser
        self.mainEventHandler = mainEventHandler
    }
    
    public func parse(
        from documentSource: XDocumentSource,
        sourceInfo: String? = nil,
        eventHandlers: [XEventHandler]? = nil,
        immediateTextHandlingNearEntities: ImmediateTextHandlingNearEntities = .atExternalEntities
    ) throws {
        try parse(
            fromData: documentSource.getData(),
            sourceInfo: sourceInfo,
            eventHandlers: eventHandlers,
            immediateTextHandlingNearEntities: immediateTextHandlingNearEntities
        )
    }
    
    public func parse(
        fromPath path: String,
        sourceInfo: String? = nil,
        eventHandlers: [XEventHandler]? = nil,
        immediateTextHandlingNearEntities: ImmediateTextHandlingNearEntities = .atExternalEntities
    ) throws {
        try parse(
            from: .path(path),
            sourceInfo: sourceInfo ?? path,
            eventHandlers: eventHandlers,
            immediateTextHandlingNearEntities: immediateTextHandlingNearEntities
        )
    }
    
    public func parse(
        fromURL url: URL,
        sourceInfo: String? = nil,
        eventHandlers: [XEventHandler]? = nil,
        immediateTextHandlingNearEntities: ImmediateTextHandlingNearEntities = .atExternalEntities
    ) throws {
        try parse(
            from: .url(url),
            sourceInfo: sourceInfo ?? url.osPath,
            eventHandlers: eventHandlers,
            immediateTextHandlingNearEntities: immediateTextHandlingNearEntities
        )
    }
    
    public func parse(
        fromText text: String,
        sourceInfo: String? = nil,
        eventHandlers: [XEventHandler]? = nil,
        immediateTextHandlingNearEntities: ImmediateTextHandlingNearEntities = .atExternalEntities
    ) throws {
        try parse(
            from: .text(text),
            sourceInfo: sourceInfo,
            eventHandlers: eventHandlers,
            immediateTextHandlingNearEntities: immediateTextHandlingNearEntities
        )
    }
    
    public func parse(
        fromData data: Data,
        sourceInfo: String? = nil,
        eventHandlers: [XEventHandler]? = nil,
        immediateTextHandlingNearEntities: ImmediateTextHandlingNearEntities = .atExternalEntities
    ) throws {
        let handlers: [XEventHandler]
        if let theEventHandlers = eventHandlers {
            handlers = [mainEventHandler] + theEventHandlers
        }
        else {
            handlers = [mainEventHandler]
        }
        try parser.parse(
            fromData: data,
            sourceInfo: sourceInfo,
            eventHandlers: handlers,
            immediateTextHandlingNearEntities: immediateTextHandlingNearEntities
        )
    }

}
