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
        if #available (iOS 15, *) {
            Logger(subsystem: "SwiftUI", category: "Task").info("Message")
        }
        #endif
    }()
 
    ```
 */

public struct LoggerMacro: ExpressionMacro {
    
    public static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        var message = ""
        var stringLiteralMessage = ""
        var privacy = ""
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
                            for expression in expressionSegment.expressions {
                                if case .stringSegment(let literalSegment) = expression.as(LabeledExprSyntax.self)?.expression.as(StringLiteralExprSyntax.self)?.segments.first {
                                    message = literalSegment.content.text
                                }
                                
                                if let text = (expression.as(LabeledExprSyntax.self)?.expression)?.as(MemberAccessExprSyntax.self)?.declName.baseName.text {
                                    privacy = text
                                }
                            }
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
            
            return privacy.isEmpty ? "\"\(message)\"" : "\"\\(\"\(message)\", privacy: .\(privacy))\""
        }
        
        let stringLiteral = """
                            {
                            #if DEBUG
                            if #available (iOS 15, *) {
                                Logger(subsystem: \"\(subsystem)\", category: \"\(category)\").\(type)(\(logMessage))
                            }
                            #endif
                            }()
                            """
        
        return ExprSyntax(stringLiteral: stringLiteral)
    }
}
