# SwiftRequests
Used to create basic get and post requests and have a JSON Object returned

#Usage
* Move the Requests.framework file to your project
* Go to the xcode project file -> General -> Embedded Binaries
    * Add Requests.framework


To use:
```swift
    import Requests

    let server = Requests(server: "http://yourserverhere.com")
```


For a GET request:
```swift
    server.getRequestWithReturnedArray(relativeUrl: "/yourUrlHere") {
        data in
        println(data)
    }
```
relativeUrl is the url you want to send a request to, 'data' is returned from that URL



For a POST request:
```swift
    server.postRequestWithReturnedArray(relativeUrl: "/yourUrlHere", postData: ["key":"value"]) {
        data in
        println(data[0]["value"])
    }
```
postData is a [String:String] Dictionary, the first item is the key, the second is the value

