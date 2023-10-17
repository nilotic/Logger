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
        var type = "debug"
        var privacy = "private"
        
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
                guard let text = element.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text else { return }
                type = text
                
            case 4:
                guard let text = element.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text else { return }
                privacy = text
                
            default:
                break
            }
        }
        
        let stringLiteral = """
                            {
                            #if DEBUG
                            if #available (iOS 15, *) {
                                Logger(subsystem: \"\(subsystem)\", category: \"\(category)\").\(type)(\"\\(\"\(message)\", privacy: .\(privacy))\")
                            }
                            #endif
                            }()
                            """
        
        return ExprSyntax(stringLiteral: stringLiteral)
    }
}
