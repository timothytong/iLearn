//
//  AppDelegate.swift
//  iLearn
//
//  Created by Timothy Tong on 2015-01-26.
//  Copyright (c) 2015 Timothy Tong. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func fetchCookie(){
        var request = NSMutableURLRequest(URL: NSURL(string: "https://cas.uwaterloo.ca/cas/login")!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        var task = session.dataTaskWithRequest(request, completionHandler: {data, responseObj, error -> Void in
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
                        var sess = SessionVars.sharedInstance
                        sess.cookie = jsessionID
                        
                        /*
                        let params = [
                        "username": "kyttong",
                        "password": "Latios1995",
                        "lt": "e1s1",
                        "_eventId": "submit",
                        "submit": "LOGIN"
                        ]
                            */
                        
                        let params = "username=kyttong&password=Latios1995&lt=e1s1&_eventId=submit&submit=LOGIN"
                        var request = NSMutableURLRequest(URL: NSURL(string: "https://cas.uwaterloo.ca/cas/login")!)
                        var session = NSURLSession.sharedSession()
                        request.HTTPMethod = "POST"
                        request.setValue("*/*", forHTTPHeaderField: "Accept")
                        request.setValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
                        request.setValue("JSESSIONID="+jsessionID, forHTTPHeaderField: "Cookie")
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
                            println("============== RESPONSE 2: \(responseObj)")
                            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                            println("Body: \(strData)")
                        })
                        task.resume()
                        
                    }
                }
            }
        })
        
        task.resume()
    }
    
   

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.fetchCookie()
        NSThread.sleepForTimeInterval(3)
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.timothytong.iLearn" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("iLearn", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("iLearn.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
}

