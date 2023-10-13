import OSLog
import Logger

func foo() {
    #Logger("Message")
    
    #Logger("Message", "KurlyLog")
    
    #Logger("Message", "KurlyDelivery", "Network")
    
    #Logger("Message", "Smile", "UI", .info)
}
