//
//  AppDelegate.swift
//  Seyahat
//
//  Created by Macintosh HD on 22.01.2020.
//  Copyright © 2020 karakurt. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //parse ı entegre etmek
        let configuration = ParseClientConfiguration { (ParseMutableClientConfiguration) in
            ParseMutableClientConfiguration.applicationId = "VqUWlpeXiadyvDPrZA5ZqjlvQtOWF6fA2gZV0Dsu"
            ParseMutableClientConfiguration.clientKey = "RDxtqh5vqr9S5yYPXjtaRr07Fd68fvGuym3EAB9F"
            ParseMutableClientConfiguration.server = "https://parseapi.back4app.com/"
            
            
        }
        Parse.initialize(with: configuration)
        
          rememberLogIn()
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

    //kullanıcıyı hatırlamak : uygulama açıldığında burda bir key varmı kontrol edilcek
    func rememberLogIn(){
        let user : String? = UserDefaults.standard.string(forKey: "userLoggedIn")
        if user != nil{
            let board : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController = board.instantiateViewController(withIdentifier: "navigationController") as! UINavigationController
            window?.rootViewController = navigationController //ekran açıldığında artık kayıtlı kullanıcım direk navigaiton viewcontrollera yöneliyor
            
        }
        
    }

}

