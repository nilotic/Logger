import OSLog
import Logger

func foo() {
    #Logger("Message")
    #Logger("Message", "SwiftUI")
    #Logger("Message", "SwiftUI", "Task")
    #Logger("Message", "SwiftUI", "Task", .info)
    
    
    // OSLogType
    #Logger("Message Info",  .info)
    #Logger("Message Debug", .debug)
    #Logger("Message Error", .error)
    #Logger("Message Fault", .fault)
    
    
    // OSLogPrivacy
    #Logger("\("(Public)  Error Message", privacy: .public)",  .info)
    #Logger("\("(Private) Error Message", privacy: .private)", .error)
}
