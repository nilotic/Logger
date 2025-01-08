import OSLog
import Logger

func foo() {
    #Logger("Message")
    #Logger("Message", "SwiftUI")
    #Logger("Message", "SwiftUI", "Task")
    #Logger("Message", "SwiftUI", "Task", .info)
    
    
    // OSLogType
    #Logger("Info Message",  .info)
    #Logger("Debug Message", .debug)
    #Logger("Error Message", .error)
    #Logger("Fault Message", .fault)
    
    
    let error = URLError(.badURL)
    #Logger(error.localizedDescription,  .info)
    #Logger(error.localizedDescription, .debug)
    #Logger(error.localizedDescription, .error)
    #Logger(error.localizedDescription, .fault)
    
}
