import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(LoggerMacros)
import LoggerMacros

let testMacros: [String: Macro.Type] = ["Logger": LoggerMacro.self]
#endif

final class LoggerTests: XCTestCase {
    
    func testMacro() throws {
        #if canImport(LoggerMacros)
        let originalSource = """
                            func foo() {
                                #Logger("Message")
                            }
                            """
        
        let expandedSource = """
                            func foo() {
                                {
                                    #if DEBUG
                                    if #available (iOS 17, *) {
                                        Logger(subsystem: "Kurly", category: "").debug("\\("Message", privacy: .private)")
                                    }
                                    #endif
                                }()
                            }
                            """
        
        assertMacroExpansion(originalSource, expandedSource: expandedSource, macros: testMacros)
        
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
