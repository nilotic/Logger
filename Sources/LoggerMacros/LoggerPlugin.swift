import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct LoggerPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [LoggerMacro.self, LoggerPrivacyMacro.self, LoggerTypeMacro.self]
}
