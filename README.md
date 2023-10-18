# Logger 
![Generic badge](https://img.shields.io/badge/Swift-5.8-orange.svg)

**A macro makes Logger run only in DEBUG**

<br>

## Requirement
- Xcode 15
- iOS 14

<br>

## Features
```swift
    #Logger("Message")
     
    // will expand to
    {
        #if DEBUG
        if #available (iOS 15, *) {
            Logger(subsystem: "Kurly", category: "").debug("Message")
        }
        #endif
    }()
```
<br>
<br>
 
## Example
```swift
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
```
