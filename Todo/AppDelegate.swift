//
//  AppDelegate.swift
//  Todo
//
//  Created by 江尚乘 on 2019-01-01.
//  Copyright © 2019 Eldon Jiang. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        do {
            _ = try Realm()

        } catch {
            print("Erron in initialiasing new realm, \(error)")
        }
        
        return true
    }

}

