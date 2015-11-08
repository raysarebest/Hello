//
//  MHAppDelegate.swift
//  Hello
//
//  Created by Michael Hulet on 11/7/15.
//  Copyright © 2015 Michael Hulet. All rights reserved.
//

import UIKit
let MHApplicationHasSetUpKey = "hasSetUp?"
@UIApplicationMain
class MHAppDelegate: UIResponder, UIApplicationDelegate{
    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool{
        // Override point for customization after application launch.
        if MHCoreDataStack.defaultStack() == nil{
            MHCoreDataStack.setDefaultToStack(MHCoreDataStack(modelName: "Hello"))
        }
        //This line runs the first time the app is launched and that time only
        NSUserDefaults.standardUserDefaults().registerDefaults([MHApplicationHasSetUpKey : false])
        //This runs every time
        if !NSUserDefaults.standardUserDefaults().boolForKey(MHApplicationHasSetUpKey){
            // TODO: Add a Core Data entity and continue
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: MHApplicationHasSetUpKey)
            let demo = NSEntityDescription.insertNewObjectForEntityForName("Display", inManagedObjectContext: MHCoreDataStack.defaultStack()!.managedObjectContext) as! Display
            demo.phrase = "Hello"
            MHCoreDataStack.defaultStack()?.saveContext()
        }
        return true
    }
    func applicationWillResignActive(application: UIApplication) -> Void{
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        MHCoreDataStack.defaultStack()?.saveContext()
    }
    func applicationDidEnterBackground(application: UIApplication) -> Void{
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        MHCoreDataStack.defaultStack()?.saveContext()
    }
    func applicationWillEnterForeground(application: UIApplication) -> Void{
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    func applicationDidBecomeActive(application: UIApplication) -> Void{
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    func applicationWillTerminate(application: UIApplication) -> Void{
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        MHCoreDataStack.defaultStack()?.saveContext()
    }
}