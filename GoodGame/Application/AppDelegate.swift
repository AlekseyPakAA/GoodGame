//
//  AppDelegate.swift
//  GoodGame
//
//  Created by alexey.pak on 08/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Instantiate a window.
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window

        // Instantiate the root view controller with dependencies injected by the container.
        window.rootViewController = StreamAssembly.makeModule(streamId: 5)//ASNavigationController(rootViewController: StreamsAssembly.makeModule())

		ASDisableLogging()

		Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
        SmilesManager.shared.scync()

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
