import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(LoggerMacros)
import LoggerMacros
#endif

final class LoggerTests: XCTestCase {
    
    func testMacro() throws {
        #if canImport(LoggerMacros)
        let originalSource = """
                            func foo() {
                                #Logger("Message", "SwiftUI", "Task", .info)
                            }
                            """
        
        let expandedSource = """
                            func foo() {
                                 #if DEBUG
                                     if #available (iOS 15, *) {
                                         Logger(subsystem: "SwiftUI", category: "Task").info("Message")
                                     }
                                 #endif
                            }
                            """
        
        assertMacroExpansion(originalSource, expandedSource: expandedSource, macros: ["Logger": LoggerMacro.self])
        
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testMacroType() throws {
        #if canImport(LoggerMacros)
        let originalSource = """
                            func foo() {
                                #Logger("Info Message",  .info)
                            }
                            """
        
        let expandedSource = """
                            func foo() {
                                #if DEBUG
                                    if #available (iOS 15, *) {
                                        Logger().info("Info Message")
                                    }
                                #endif
                            }
                            """
        
        assertMacroExpansion(originalSource, expandedSource: expandedSource, macros: ["Logger": LoggerTypeMacro.self])
        
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testOSLogPrivacy() throws {
        #if canImport(LoggerMacros)
        let originalSource = """
                            func foo() {
                                #Logger("(Private) Error Message", .private, .error)
                            }
                            """
        
        let expandedSource = """
                            func foo() {
                                #if DEBUG
                                    if #available (iOS 15, *) {
                                        Logger().error("\("(Private) Error Message", privacy: .private)")
                                    }
                                #endif
                            }
                            """
        
        assertMacroExpansion(originalSource, expandedSource: expandedSource, macros: ["Logger": LoggerTypeMacro.self])
        
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
