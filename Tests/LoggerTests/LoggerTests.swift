import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import LoggerMacros

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
                                {
                                    #if DEBUG
                                    if #available (iOS 15, *) {
                                        Logger(subsystem: "SwiftUI", category: "Task").info("Message")
                                    }
                                    #endif
                                }()
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
                                #Logger("Message", .info)
                            }
                            """
        
        let expandedSource = """
                            func foo() {
                                {
                                    #if DEBUG
                                    if #available (iOS 15, *) {
                                        Logger().info("Message")
                                    }
                                    #endif
                                }()
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
                                #Logger("\\("(Public)  Error Message", privacy: .public)", .info)
                            }
                            """
        
        let expandedSource = """
                            func foo() {
                                {
                                    #if DEBUG
                                    if #available (iOS 15, *) {
                                        Logger().info("\\("(Public)  Error Message", privacy: .public)")
                                    }
                                    #endif
                                }()
                            }
                            """
        
        assertMacroExpansion(originalSource, expandedSource: expandedSource, macros: ["Logger": LoggerTypeMacro.self])
        
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
