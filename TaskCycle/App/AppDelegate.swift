//
//  AppDelegate.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-14.
//

import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {

        FirebaseApp.configure()

        return true
    }

    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any ]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
}

