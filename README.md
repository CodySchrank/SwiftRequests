# SwiftRequests
Use to create basic get and post requests

#Usage
* Move the Requests.framework file to your project
* Go to the xcode project file -> General -> Embedded Binaries
    * Add Requests.framework
* Import and use:
```swift
import Requests

let server = Requests(server: "http://yourserverhere.com")
```

