# SwiftRequests
Used to create basic get and post requests and have a JSON Object returned

#Usage
* Move the RequestsFramework.swift file to your project


To use:
```swift
    let server = Requests(server: "http://yourserverhere.com")
```
-



For a GET request:
```swift
    server.getRequestWithReturnedArray(relativeUrl: "/yourUrlHere") {
        data in
        println(data)
    }
```
relativeUrl is the url you want to send a request to, 'data' is what was returned from that URL

-



For a POST request:
```swift
    server.postRequestWithReturnedArray(relativeUrl: "/yourUrlHere", postData: ["key":"value"]) {
        data in
        println(data[0]["value"])
    }
```
postData is a [String:String] Dictionary, the first item is the key, the second is the value.
You can post as many things as you need
```swift
["name":"Michael","age":30,"baller": true]
```



