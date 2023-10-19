import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/**
    ```swift
    #Logger("Message")
     
    // will expand to
    {
        #if DEBUG
        if #available (iOS 15, *) {
            Logger().debug("Message")
        }
        #endif
    }()
 
    ```
 */

public struct LoggerTypeMacro: ExpressionMacro {
    
    public static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        var message = ""
        var privacy = ""
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
                }
                
            case 1:
                guard let text = element.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text else { return }
                type = text
                
            default:
                break
            }
        }
        
        let logMessage = privacy.isEmpty ? "\"\(message)\"" : "\"\\(\"\(message)\", privacy: .\(privacy))\""
        
        let stringLiteral = """
                            {
                            #if DEBUG
                            if #available (iOS 15, *) {
                                Logger().\(type)(\(logMessage))
                            }
                            #endif
                            }()
                            """
        
        return ExprSyntax(stringLiteral: stringLiteral)
    }
}
