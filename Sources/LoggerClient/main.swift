import OSLog
import Logger

func foo() {
    #Logger("Message")
    #Logger("Message", "MarketKurly")
    #Logger("Message", "MarketKurly", "Network")
    #Logger("Message", "MarketKurly", "Network", .info)
    #Logger("Message", "MarketKurly", "Network", .info, .public)
    
    #Logger("Message Info",  .info)
    #Logger("Message Debug", .debug)
    #Logger("Message Error", .error)
    #Logger("Message Fault", .fault)
}
