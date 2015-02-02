//
//  APICaller.swift
//  iLearn
//
//  Created by Timothy Tong on 2015-01-29.
//  Copyright (c) 2015 Timothy Tong. All rights reserved.
//

import Foundation
class APICaller{
    class func fetchCookieWithCompletionHandler(handler:(String)->(), errorHandler failureHandler:()->()){
        var request = NSMutableURLRequest(URL: NSURL(string: "https://cas.uwaterloo.ca/cas/login")!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        var task = session.dataTaskWithRequest(request, completionHandler: {data, responseObj, error -> Void in
            if error != nil{
                println("ERROR WHEN FETCHING JSESSIONID!")
                failureHandler()
            }
            else{
                println("============== RESPONSE 1: \(responseObj)")
                if let httpResponse = responseObj as? NSHTTPURLResponse {
                    if let cookies = httpResponse.allHeaderFields["Set-Cookie"] as? String {
                        println("Extracted cookie: \(cookies)")
                        let cookie:NSString = cookies
                        if cookies.rangeOfString("JSESSIONID=") != nil{
                            var start = cookies.rangeOfString("JSESSIONID=")!.endIndex
                            var substring : NSString = cookies.substringFromIndex(start)
                            let jsessionID : String = substring.substringToIndex(32)
                            println("JSESSIONID: "+jsessionID)
                            handler(jsessionID)
                        }
                    }
                }
            }
        })
        task.resume()
    }
    class func loginWithParams(params:String, jsessionID cookie:String, successHandlerWithCASTGCCookieParam completionHandler:(String)->(), errorHandler failureHandler:()->()){
        var request = NSMutableURLRequest(URL: NSURL(string: "https://cas.uwaterloo.ca/cas/login")!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
        request.setValue("JSESSIONID="+cookie, forHTTPHeaderField: "Cookie")
        request.setValue("en-US,en;q=0.8,zh-CN;q=0.6,zh;q=0.4", forHTTPHeaderField: "Accept-Language")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.setValue("cas.uwaterloo.ca", forHTTPHeaderField: "Host")
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        let postData = params.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
        request.setValue("\(postData!.length)", forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postData!
        println("REQUEST LENGTH - \(postData!.length): \n \(postData!.description)")
        var task = session.dataTaskWithRequest(request, completionHandler: {data, responseObj, error -> Void in
            if error != nil{
                println("ERROR WHEN LOGIN!")
                failureHandler()
            }
            else{
                println("SUCCESS ============== RESPONSE : \(responseObj)")
                //                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                //                println("Body: \(strData)")
                if let httpResponse = responseObj as? NSHTTPURLResponse {
                    if let cookies = httpResponse.allHeaderFields["Set-Cookie"] as? String {
                        println("Extracted cookie: \(cookies)")
                        let cookie:NSString = cookies
                        if cookies.rangeOfString("CASTGC=") != nil{
                            var start = cookies.rangeOfString("CASTGC=")!.endIndex
                            var substring : String = cookies.substringFromIndex(start)
                            println("SUBSTRING:::::\n\n "+substring)
                            var end = substring.rangeOfString("-cas")!.endIndex
                            let CASTGC = substring.substringToIndex(end)
                            println("CASTGC: "+CASTGC)
                            completionHandler(CASTGC)
                        }
                    }
                }
                
            }
            
        })
        task.resume()
        
    }
}