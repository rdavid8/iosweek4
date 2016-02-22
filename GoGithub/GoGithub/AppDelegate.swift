//
//  AppDelegate.swift
//  GoGithub
//
//  Created by Ryan David on 2/22/16.
//  Copyright © 2016 Ryan David. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        
        return true
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        GithubOAuth.shared.tokenRequestWithCallback(url, options: SaveOption.UserDefaults) { (success) in
            if success {
                print("We have the token")
            }
        }
        return true
    }

    }

