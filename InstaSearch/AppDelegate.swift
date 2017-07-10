//
//  AppDelegate.swift
//  InstaSearch
//
//  Created by admin on 27.06.17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var instagramAPI = InstagramAPIInteractor()
    var databaseInteractor: DatabaseInteractor!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //try? FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
        databaseInteractor =  DatabaseInteractor()
        Alamofire.SessionManager.default.adapter = AccessTokenRequestAdapter()
        
        let rootController = window?.rootViewController as? UITabBarController
        let navHomeController = (rootController?.viewControllers?[0] as? UINavigationController)
        let navBookmarksController = rootController?.viewControllers?[1] as? UINavigationController
        
        let homeController = navHomeController?.topViewController as? HomePageController
        let bookmarksController = navBookmarksController?.topViewController as? BookmarksController
        
        if let controller = homeController {
            let presenter = HomePagePresenterImpl(view: controller, instagramAPI: instagramAPI, databaseInteractor: databaseInteractor)
            controller.presenter = presenter
        }
        
        if let controller = bookmarksController {
            let presenter = BookmarksPresenterImpl(view: controller, databaseInteractor: databaseInteractor)
            controller.presenter = presenter
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

