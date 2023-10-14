# Logger 
![Generic badge](https://img.shields.io/badge/Swift-5.8-orange.svg)

**A macro makes Logger run only in DEBUG**

<br>

## Requirement
- Xcode 15
- iOS 14

<br>

## Features
    
     #Logger("Message")
    
     // Expand to
     {
         #if DEBUG
         Logger(subsystem: "Kurly", category: "").debug("\("Message", privacy: .private)")
         #endif
     }()

<br>
<br>
 
## Example

     #Logger("Message")
     #Logger("Message", "MarketKurly")
     #Logger("Message", "MarketKurly", "Network")
     #Logger("Message", "MarketKurly", "Network", .public)
     #Logger("Message", "MarketKurly", "Network", .public, .info)
   
     
     #Logger("Message Info",  .info)
     #Logger("Message Debug", .debug)
     #Logger("Message Error", .error)
     #Logger("Message Fault", .fault)
