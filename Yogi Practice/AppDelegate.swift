//
//  AppDelegate.swift
//  Yogi Practice
//
//  Created by margot on 2017-09-27.
//  Copyright © 2017 foxberryfields. All rights reserved.
//

import UIKit
import CoreData
import Firebase
//import GoogleSignIn;
//import FBSDKCoreKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?


    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        FirebaseApp.configure()
        print("got to a delegate")
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        
        if Auth.auth().currentUser == nil {
            print("is nil user")
            
            window?.makeKeyAndVisible()
            window?.rootViewController?.present(loginVC, animated: true, completion: nil)
            
        }
        
        else if (UserDefaults.standard.value(forKey: "nickname") as? String) == nil // user default name == nil go to Home vc
        {
            let userID = Auth.auth().currentUser?.uid
            let ref = Database.database().reference()
            ref.child("users").child(userID!).child("userInfo").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get time value
                
                if snapshot.hasChild("nickname"){
                    
                    print("nickname  exist - save to user defaults and go to default screen ")
                    if (snapshot.value as? NSDictionary) != nil {
                        
                        //(UserDefaults.standard.value(forKey: "nickname") = value["nickname"] as? String
                    }
                    
                } else{
                    
                    print("nickname doesn't exist, go to on-boarding")
                    let onboardVC = storyboard.instantiateViewController(withIdentifier: "OnboardingVC")
                    self.window?.makeKeyAndVisible()
                    self.window?.rootViewController?.present(onboardVC, animated: true, completion: nil)
                }
                })
        }
        
        return true
    
}

    
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {

            let emailSignIn = GIDSignIn.sharedInstance().handle(url,
                                                                sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                                annotation: options[UIApplicationOpenURLOptionsKey.annotation])
//            let facebookSignIn = FBSDKApplicationDelegate.sharedInstance().application(
//                application,
//                open: url,
//                sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?,
//                annotation: options[UIApplicationOpenURLOptionsKey.annotation])
            return emailSignIn //|| facebookSignIn
            
    }

    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        // error handling
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    func handleLogin() {
        print("Logging in from App delegate")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let meditationVController: MeditationVC = (storyboard.instantiateViewController(withIdentifier: "MeditationVC") as? MeditationVC)!
        
            meditationVController.view.frame = (self.window!.frame)
            self.window!.addSubview(meditationVController.view)
            self.window!.bringSubview(toFront: meditationVController.view)
        
        //self.present(meditationVController, animated: true, complition: nil)
    }

    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        //GIDSignIn.sharedInstance().signOut()
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Yogi_Practice")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

