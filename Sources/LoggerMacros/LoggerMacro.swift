import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/**
    ```swift
    #Logger("Message", "SwiftUI", "Task", .info)
 
    // will expand to
    {
        #if DEBUG
        Logger(subsystem: "SwiftUI", category: "Task").info("Message")
        #endif
    }()
 
    ```
 */

public struct LoggerMacro: ExpressionMacro {
    
    public static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        var message = ""
        var stringLiteralMessage = ""
        var subsystem = ""
        var category = "Default"
        var type = "debug"
        
        node.argumentList.enumerated().forEach { i, element in
            switch i {
            case 0:
                if let segments = element.expression.as(StringLiteralExprSyntax.self)?.segments {
                    for segment in segments {
                        switch segment {
                        case .stringSegment(let literalSegment):
                            guard !literalSegment.content.text.isEmpty else { continue }
                            message = literalSegment.content.text
                            
                        case .expressionSegment(let expressionSegment):
                            message = expressionSegment.description
                        }
                    }
                    
                } else if let memberAccessExprSyntax = element.expression.as(MemberAccessExprSyntax.self) {
                    stringLiteralMessage = memberAccessExprSyntax.description
                }
                
            case 1:
                guard case .stringSegment(let literalSegment)? = element.expression.as(StringLiteralExprSyntax.self)?.segments.first else { return }
                subsystem = literalSegment.content.text
                
            case 2:
                guard case .stringSegment(let literalSegment)? = element.expression.as(StringLiteralExprSyntax.self)?.segments.first else { return }
                category = literalSegment.content.text
                
            case 3:
                guard let text = element.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text else { return }
                type = text
                
            default:
                break
            }
        }
        
        var logMessage: String {
            if message.isEmpty, !stringLiteralMessage.isEmpty {
                message = "\\(\(stringLiteralMessage))"
            }
            
            return "\"\(message)\""
        }
        
        let stringLiteral = """
                            {
                            #if DEBUG
                            Logger(subsystem: \"\(subsystem)\", category: \"\(category)\").\(type)(\(logMessage))
                            #endif
                            }()
                            """
        
        return ExprSyntax(stringLiteral: stringLiteral)
    }
}
