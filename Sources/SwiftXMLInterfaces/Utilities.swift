//===--- Utilities.swift --------------------------------------------------===//
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

enum Platform {
    case macOSIntel
    case macOSARM
    case LinuxIntel
    case WindowsIntel
    case Unknown
    public var description: String? {
        switch self {
        case .macOSARM: return "macOS.ARM"
        case .macOSIntel: return "macOS.Intel"
        case .LinuxIntel: return "RedHat7.Intel" //TODO: Fix mismatch.
        case .WindowsIntel: return "Windows.Intel"
        case .Unknown: return nil
        }
    }
}

func platform() -> Platform {
    #if os(macOS)
        #if arch(x86_64)
            return Platform.macOSIntel
        #else
            return Platform.macOSARM
        #endif
    #elseif os(Linux)
        #if arch(x86_64)
            return Platform.LinuxIntel
        #else
            return Platform.Unknown
        #endif
    #else
        #if arch(x86_64)
            return Platform.WindowsIntel
        #else
            return Platform.Unknown
        #endif
    #endif
}

func pathSeparator() -> String {
    return platform() == Platform.WindowsIntel ? "\\" : "/"
}

extension URL {
    var osPath: String {
        get {
            self.path.replacing("/", with: pathSeparator())
        }
    }
}
