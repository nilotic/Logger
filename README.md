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
        Logger().debug("Message")
        #endif
    }()
```
<br>
<br>
 
## Example
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
    
```
