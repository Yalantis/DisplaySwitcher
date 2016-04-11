//
//  AppDelegate.swift
//  YALLayoutTransitioning
//
//  Created by Roman on 23.02.16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.titleTextAttributes = ([NSFontAttributeName: UIFont(name: "Dosis-SemiBold", size: 21)!,
                NSForegroundColorAttributeName: UIColor.navigationBarTintColor()])
        UINavigationBar.appearance().barTintColor = UIColor.navigationBarBackgroundColor()
        navigationBarAppearace.translucent = false
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
      
        UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).backgroundColor = .blackColor()
        UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).tintColor = .lightGrayColor()
        UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).textColor = .lightGrayColor()
        
        return true
    }
    

}

