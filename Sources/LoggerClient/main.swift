import OSLog
import Logger

func foo() {
    #Logger("Message")
    #Logger("Message", "MarketKurly")
    #Logger("Message", "MarketKurly", "Network")
    #Logger("Message", "MarketKurly", "Network", .info)
    
    
    // OSLogType
    #Logger("Mesage  Info",  .info)
    #Logger("Message Debug", .debug)
    #Logger("Message Error", .error)
    #Logger("Message Fault", .fault)
    
    
    // OSLogPrivacy
    #Logger("\("(Public)  Error Message", privacy: .public)",  .info)
    #Logger("\("(Private) Error Message", privacy: .private)", .error)
}
