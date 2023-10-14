import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct LoggerPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [LoggerMacro.self, LoggerTypeMacro.self]
}
