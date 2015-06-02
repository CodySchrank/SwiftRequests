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
    
    private func parseJSON(inputData: NSData?) -> NSArray? {
        //SOMETIMES BROKEN
        var error: NSError?
        if let data = inputData {
            var arrOfObjects = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSArray
            return arrOfObjects
        } else {
            return nil
        }
    }
    
    public func getRequestWithReturnedArray(#relativeUrl: String,completed: (Array<AnyObject>)->()){
        if let
            urlToReq = NSURL(string: relativeUrl, relativeToURL: self.server),
            data = NSData(contentsOfURL: urlToReq),
            arrOfObjects = self.parseJSON(data) {
                completed(arrOfObjects as Array<AnyObject>)
        } else {
            println("Something went wrong")
        }
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
                if let arrOfObjects = self.parseJSON(data) {
                    completed(arrOfObjects as Array<AnyObject>)
                } else {
                    println("Something went wrong")
                }
            }
        } else {
            println("Route does Not Exist")
        }
    }
    
}