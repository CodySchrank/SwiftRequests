//
//  Requests.swift
//  Requests
//
//  Created by Cody Schrank on 6/1/15.
//  Copyright (c) 2015 TheTapAttack. All rights reserved.
//

import Foundation

public class Requests {
    public var server: NSURL? = nil
    
    public init(server: String) {
        self.server = NSURL(string: server)
    }
    
    private func parseJSONasArray(inputData: NSData?) -> Array<AnyObject>? {
        //SOMETIMES BROKEN
        var error: NSError?
        if let data = inputData {
            var objects: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error)
            if error != nil {
                println(error)
                return nil
            } else {
                if let unwrappedObjects: AnyObject = objects {
                    if let parsedObjects = unwrappedObjects as? Array<AnyObject> {
                        return parsedObjects
                    } else {
                        return nil
                    }
                } else {
                    println("PARSE FAILED")
                    return nil
                }
            }
        } else {
            println("DATA INVALID")
            return nil
        }
    }
    
    private func parseJSONasDictionary(inputData: NSData?) -> Dictionary<String,AnyObject>? {
        //SOMETIMES BROKEN
        var error: NSError?
        if let data = inputData {
            var objects: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error)
            if error != nil {
                println(error)
                return nil
            } else {
                if let unwrappedObjects: AnyObject = objects {
                    if let parsedObjects = unwrappedObjects as? Dictionary<String,AnyObject> {
                        return parsedObjects
                    } else {
                        return nil
                    }
                } else {
                    println("PARSE FAILED")
                    return nil
                }
            }
        } else {
            println("DATA INVALID")
            return nil
        }
    }
    
    public func getRequestWithReturnedArray(#relativeUrl: String,completed: (Array<AnyObject>)->()){
        if let
            urlToReq = NSURL(string: relativeUrl, relativeToURL: self.server),
            data = NSData(contentsOfURL: urlToReq),
            arrOfObjects = self.parseJSONasArray(data) {
                completed(arrOfObjects as Array<AnyObject>)
        } else {
            println("Something went wrong")
        }
    }
    
    public func getImageFromPath(#relativeUrl: String,completed: (UIImage)->()){
        let url = NSURL(string: relativeUrl, relativeToURL: self.server)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let image = UIImage(data: data)
            completed(image!)
        }
        
        task.resume()
    }
    
    public func getDataFromPath(#relativeUrl: String,completed: (NSData)->()){
        let url = NSURL(string: relativeUrl, relativeToURL: self.server)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            completed(data)
        }
        
        task.resume()
    }
    
    
    public func postRequestWithReturnedArray(#relativeUrl: String,postData: [String:String],completed: (Array<AnyObject>) -> ()) {
        if let urlToReq = NSURL(string: relativeUrl, relativeToURL: self.server) {
            let request = NSMutableURLRequest(URL: urlToReq)
            request.HTTPMethod = "POST"
            var bodyData = ""
            var iterations = 0
            for (key,value) in postData {
                if iterations == 0 {
                    bodyData += "\(key)=\(value)"
                } else {
                    bodyData += "&\(key)=\(value)"
                }
                ++iterations
            }
            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                response, data, error in
                if error != nil {
                    println(error)
                } else {
                    if let arrOfObjects = self.parseJSONasArray(data) {
                        completed(arrOfObjects as Array<AnyObject>)
                    } else {
                        println("Something might have gone wrong:",response)
                    }
                }
            }
        } else {
            println("Route does Not Exist")
        }
    }
    
    public func postRequestWithReturnedDictionary(#relativeUrl: String,postData: [String:String],completed: (Dictionary<String,AnyObject>?) -> ()) {
        if let urlToReq = NSURL(string: relativeUrl, relativeToURL: self.server) {
            let request = NSMutableURLRequest(URL: urlToReq)
            request.HTTPMethod = "POST"
            var bodyData = ""
            var iterations = 0
            for (key,value) in postData {
                if iterations == 0 {
                    bodyData += "\(key)=\(value)"
                } else {
                    bodyData += "&\(key)=\(value)"
                }
                ++iterations
            }
            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                response, data, error in
                if error != nil {
                    println(error)
                } else {
                    if let arrOfObjects = self.parseJSONasDictionary(data) {
                        completed(arrOfObjects as Dictionary<String,AnyObject>)
                    } else {
                        println("Something might have gone wrong:",response)
                        completed(nil)
                    }
                }
            }
        } else {
            println("Route does Not Exist")
        }
    }
    
    
    public func postRequestWithReturnedBool(#relativeUrl: String,postData: [String:String],completed: (Bool) -> ()) {
        var success = false
        if let urlToReq = NSURL(string: relativeUrl, relativeToURL: self.server) {
            let request = NSMutableURLRequest(URL: urlToReq)
            request.HTTPMethod = "POST"
            var bodyData = ""
            var iterations = 0
            for (key,value) in postData {
                if iterations == 0 {
                    bodyData += "\(key)=\(value)"
                } else {
                    bodyData += "&\(key)=\(value)"
                }
                ++iterations
            }
            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                response, data, error in
                if error != nil {
                    println(error)
                } else {
                    let httpResponse = response as! NSHTTPURLResponse
                    if httpResponse.statusCode == 200 {
                        completed(true)
                    } else {
                        completed(false)
                    }
                }
            }
        } else {
            println("Route does Not Exist")
        }
    }
    
    public func postDataRequestWithReturnedBool(#relativeUrl: String,postData: [String:AnyObject],completed: (Bool) -> ()) {
        var success = false
        if let urlToReq = NSURL(string: relativeUrl, relativeToURL: self.server) {
            let request = NSMutableURLRequest(URL: urlToReq)
            request.HTTPMethod = "POST"
            var bodyData = ""
            var iterations = 0
            for (key,value) in postData {
                if iterations == 0 {
                    bodyData += "\(key)=\(value)"
                } else {
                    bodyData += "&\(key)=\(value)"
                }
                ++iterations
            }
            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                response, data, error in
                if error != nil {
                    println(error)
                } else {
                    let httpResponse = response as! NSHTTPURLResponse
                    if httpResponse.statusCode == 200 {
                        completed(true)
                    } else {
                        completed(false)
                    }
                }
            }
        } else {
            println("Route does Not Exist")
        }
    }
    
    public func postImageRequestWithReturnedBool(#relativeUrl: String,image: NSData, imageType: String?, postData: [String:AnyObject], completed: (Bool) -> ()) {
        if let urlToReq = NSURL(string: relativeUrl, relativeToURL: self.server) {
            let request = NSMutableURLRequest(URL: urlToReq)
            request.HTTPMethod = "POST"
            request.HTTPShouldHandleCookies = false
            request.timeoutInterval = 30
            let boundary = "bound"
            let contentType = "multipart/form-data; boundary=\(boundary)"
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
            
            let imageId = NSProcessInfo.processInfo().globallyUniqueString
            let body = NSMutableData()
            
            for (key,value) in postData {
                body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
                body.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
                body.appendData("\(value as! String)\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            }
            
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            body.appendData("Content-Disposition: form-data; name=\"\(boundary)\"; filename=\"\(imageId)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            
            if let imageType = imageType {
                body.appendData("Content-Type:image/\(imageType)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            }
            
            body.appendData(image)
            body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            
            body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            request.HTTPBody = body
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                response, data, error in
                if error != nil {
                    println(error)
                } else {
                    let httpResponse = response as! NSHTTPURLResponse
                    if httpResponse.statusCode == 200 {
                        completed(true)
                    } else {
                        completed(false)
                    }
                }
            }
        } else {
            println("Route does Not Exist")
        }
    }
    
    public func isConnectedToNetwork() -> Bool {
        
        var Status:Bool = false
        let url = self.server
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: NSURLResponse?
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: nil) as NSData?
        
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                Status = true
            }
        }
        
        return Status
    }
}