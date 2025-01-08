import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/**
    ```swift
    #Logger("Debug Message", .debug)
     
    // will expand to
    {
        #if DEBUG
        Logger().debug("Debug Message")
        #endif
    }()
 
    ```
 */

public struct LoggerTypeMacro: ExpressionMacro {
    
    public static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        var message = ""
        var stringLiteralMessage = ""
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
                            Logger().\(type)(\(logMessage))
                            #endif
                            }()
                            """
        
        return ExprSyntax(stringLiteral: stringLiteral)
    }
}
