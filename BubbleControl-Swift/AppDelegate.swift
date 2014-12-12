//
//  AppDelegate.swift
//  BubbleControl-Swift
//
//  Created by Cem Olcay on 11/12/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var bubble: BubbleControl!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        bubble = BubbleControl (size: CGSizeMake(80, 80))
        bubble.image = UIImage (named: "basket.png")
        bubble.navButtonAction = {
            println("pressed in nav bar")
            self.bubble!.popFromNavBar()
        }
        bubble.contentView = {
            
            let min: CGFloat = 50
            let max: CGFloat = self.window!.h - 250
            let randH = min + CGFloat(random()%Int(max-min))
            
            let v = UIView (frame: CGRect (x: 0, y: 0, width: self.window!.w, height: max))
            v.backgroundColor = UIColor.grayColor()
            
            let label = UILabel (frame: CGRect (x: 10, y: 10, width: v.w, height: 20))
            label.text = "test text"
            v.addSubview(label)
            
            return v
        }

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
    }
}

