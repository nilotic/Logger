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
    #Logger("Message")
    
     // will expand to
     {
         #if DEBUG
         if #available (iOS 15, *) {
             Logger(subsystem: "Kurly", category: "").debug("\("Message", privacy: .private)")
         }
         #endif
     }()
 
    ```
 
    # Example #
     ```swift
     #Logger("Message")
     #Logger("Message", "MarketKurly")
     #Logger("Message", "MarketKurly", "Network")
     #Logger("Message", "MarketKurly", "Network", .info)
     ```
*/
@freestanding(expression)
public macro Logger(_ message: String, _ subsystem: String = "Kurly", _ category: String = "", _ type: OSLogType = .info, _ privacy: OSLogPrivacy = .private) = #externalMacro(module: "LoggerMacros", type: "LoggerMacro")


/**
     A macro makes Logger run only in DEBUG

     - Parameters:
        - message: The interpolated string that the logger writes to the log. Each of the message’s interpolations can specify individual formatting and privacy options. For more information, see Message Argument Formatters.
        - type: The message’s log level, which determines the severity of the message and whether the system persists it to disk. For possible values, see OSLogType.

 
    ```swift
    #Logger("Message Debug", .debug)
    
     // will expand to
     {
         #if DEBUG
         if #available (iOS 15, *) {
             Logger(subsystem: "Kurly", category: "").debug("\("Message", privacy: .private)")
         }
         #endif
     }()
 
    ```
 
    # Example #
     ```swift
     #Logger("Message Info",  .info)
     #Logger("Message Debug", .debug)
     #Logger("Message Error", .error)
     #Logger("Message Fault", .fault)
     ```
*/
@freestanding(expression)
public macro Logger(_ message: String, _ type: OSLogType = .info) = #externalMacro(module: "LoggerMacros", type: "LoggerTypeMacro")
