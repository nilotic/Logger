import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import OSLog

/**
 Implementation of the `Logger` macro, which takes an expression  of any type and produces a tuple containing the value of that expression and the source code that produced the value. For example
    
     #Logger("Message")
 
 will expand to
 
     ```
     {
         #if DEBUG
         if #available (iOS 17, *) {
             Logger(subsystem: "Kurly", category: "").debug("\\("Message", privacy: .private)")
         }
         #endif
     }()
     ```
 */

public struct LoggerMacro: ExpressionMacro {
    
    public static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        var message = ""
        var subsystem = "Kurly"
        var category = ""
        var type = ".debug"
        
        node.argumentList.enumerated().forEach { i, element in
            switch i {
            case 0:
                guard case .stringSegment(let literalSegment)? = element.expression.as(StringLiteralExprSyntax.self)?.segments.first else { return }
                message = literalSegment.content.text
                
            case 1:
                guard case .stringSegment(let literalSegment)? = element.expression.as(StringLiteralExprSyntax.self)?.segments.first else { return }
                subsystem = literalSegment.content.text
                
            case 2:
                guard case .stringSegment(let literalSegment)? = element.expression.as(StringLiteralExprSyntax.self)?.segments.first else { return }
                category = literalSegment.content.text
                
            case 3:
                guard let description = node.argumentList.last?.expression.description else { return }
                type = description
                
            default:
                break
            }
        }
        
        let stringLiteral = """
                            {
                            #if DEBUG
                            if #available(iOS 17, *) {
                                Logger(subsystem: \"\(subsystem)\", category: \"\(category)\")\(type)(\"\\(\"\(message)\", privacy: .private)\")
                            }
                            #endif
                            }()
                            """
        
        return ExprSyntax(stringLiteral: stringLiteral)
    }
}
