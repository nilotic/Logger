// The Swift Programming Language
// https://docs.swift.org/swift-book

import OSLog

/**
     A macro makes Logger run only in DEBUG

     - Parameters:
        - message: The interpolated string that the logger writes to the log. Each of the message’s interpolations can specify individual formatting and privacy options. For more information, see Message Argument Formatters.
        - subsystem: The string that identifies the subsystem that emits signposts. Typically, you use the same value as your app’s bundle ID. For more information, see CFBundleIdentifier.
        - category: The string that the system uses to categorize emitted signposts.
        - type: The message’s log level, which determines the severity of the message and whether the system persists it to disk. For possible values, see OSLogType.

 

     ```swift
     #Logger("Message", "SwiftUI", "Task", .info)

     // will expand to
     #if DEBUG
         if #available (iOS 15, *) {
             Logger(subsystem: "SwiftUI", category: "Task").info("Message")
         }
     #endif
 
     ```
 
 
     # Example #
     ```swift
     #Logger("Message")
     #Logger("Message", "SwiftUI")
     #Logger("Message", "SwiftUI", "Task")
     #Logger("Message", "SwiftUI", "Task", .info)
     
     
     // OSLogType
     #Logger("Info Message",  .info)
     #Logger("Debug Message", .debug)
     #Logger("Error Message", .error)
     #Logger("Fault Message", .fault)
     
     
     // OSLogPrivacy
     #Logger("(Public)  Debug Message", .public,  .debug)
     #Logger("(Private) Error Message", .private, .error)
 
     ```
*/
@freestanding(expression)
public macro Logger(_ message: String, _ subsystem: String = "", _ category: String = "", _ type: OSLogType = .debug) = #externalMacro(module: "LoggerMacros", type: "LoggerMacro")


/**
     A macro makes Logger run only in DEBUG

     - Parameters:
        - message: The interpolated string that the logger writes to the log. Each of the message’s interpolations can specify individual formatting and privacy options. For more information, see Message Argument Formatters.
        - privacy: The privacy options that determine when to redact or display values in log messages.
        - type: The message’s log level, which determines the severity of the message and whether the system persists it to disk. For possible values, see OSLogType.

  
 
    ```swift
    #Logger("(Private) Error Message", .private, .error)
      
    // will expand to
    #if DEBUG
        if #available (iOS 15, *) {
            Logger().error("\("(Private) Error Message", privacy: .private)")
        }
    #endif
 
    ```
 
 
    # Example #
 
    ```swift
     #Logger("Message")
     #Logger("Message", "SwiftUI")
     #Logger("Message", "SwiftUI", "Task")
     #Logger("Message", "SwiftUI", "Task", .info)
     
     
     // OSLogType
     #Logger("Info Message",  .info)
     #Logger("Debug Message", .debug)
     #Logger("Error Message", .error)
     #Logger("Fault Message", .fault)
     
     
     // OSLogPrivacy
     #Logger("(Public)  Debug Message", .public,  .debug)
     #Logger("(Private) Error Message", .private, .error)
 
    ```
*/
@freestanding(expression)
public macro Logger(_ message: OSLogMessage, _ privacy: OSLogPrivacy = .public, _ type: OSLogType = .debug) = #externalMacro(module: "LoggerMacros", type: "LoggerPrivacyMacro")

/**
     A macro makes Logger run only in DEBUG

     - Parameters:
        - message: The interpolated string that the logger writes to the log. Each of the message’s interpolations can specify individual formatting and privacy options. For more information, see Message Argument Formatters.
        - type: The message’s log level, which determines the severity of the message and whether the system persists it to disk. For possible values, see OSLogType.

  
 
    ```swift
    #Logger("Debug Message", .debug)
      
    // will expand to
    #if DEBUG
        if #available (iOS 15, *) {
            Logger().debug("Debug Message")
        }
    #endif
 
    ```
 
 
    # Example #
 
    ```swift
     #Logger("Message")
     #Logger("Message", "SwiftUI")
     #Logger("Message", "SwiftUI", "Task")
     #Logger("Message", "SwiftUI", "Task", .info)
     
     
     // OSLogType
     #Logger("Info Message",  .info)
     #Logger("Debug Message", .debug)
     #Logger("Error Message", .error)
     #Logger("Fault Message", .fault)
     
     
     // OSLogPrivacy
     #Logger("(Public)  Debug Message", .public,  .debug)
     #Logger("(Private) Error Message", .private, .error)
 
    ```
*/
@freestanding(expression)
public macro Logger(_ message: String, _ type: OSLogType = .debug) = #externalMacro(module: "LoggerMacros", type: "LoggerTypeMacro")
