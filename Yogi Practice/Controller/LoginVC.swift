//
//  LoginVC.swift
//  Yogi Practice
//
//  Created by margot on 2017-09-27.
//  Copyright © 2017 foxberryfields. All rights reserved.
//

import UIKit
import Firebase
//import FBSDKLoginKit

class LoginVC: UIViewController, GIDSignInUIDelegate {

    
    @IBAction func loginEmailButton(_ sender: Any) {
        let signUpVC = storyboard?.instantiateViewController(withIdentifier: "SignUpVC")
        present(signUpVC!, animated: true, completion: nil)
    }
    
    @IBAction func loginFbButton(_ sender: Any) {
//        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
//        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
//            if (error == nil){
//                let fbloginresult : FBSDKLoginManagerLoginResult = result!
//                if(fbloginresult.grantedPermissions.contains("email"))
//                {
//                    print("Successfully signed in user")
//                }
//            }
//        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            
            
            
            if (UserDefaults.standard.value(forKey: "nickname") as? String) != nil {
                handleLogin()
            }

            else if (UserDefaults.standard.value(forKey: "nickname") as? String) == nil // user default name == nil go to Home vc
            {
                let userID = Auth.auth().currentUser?.uid
                let ref = Database.database().reference()
                ref.child("users").child(userID!).child("userInfo").observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get time value
                    
                    if snapshot.hasChild("nickname"){
                        
                        print("nickname  exist - save to user defaults and go to default screen ")
                        if let value = snapshot.value as? NSDictionary {
                            let nickname = value["username"] as? String ?? ""
                            UserDefaults.standard.set(nickname, forKey: "nickname")
                            self.handleLogin()
                        }
                        
                    } else{
                        
                        print("nickname doesn't exist, go to on-boarding")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let onboardVC = storyboard.instantiateViewController(withIdentifier: "OnboardingVC")
                        self.present(onboardVC, animated: true, completion: nil)
                    }
                })
            }
                
/////////////
                
            else {
                print("nickname doesn't exist, go to on-boarding")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let onboardVC = storyboard.instantiateViewController(withIdentifier: "OnboardingVC")
                self.present(onboardVC, animated: true, completion: nil)
                //dismiss(animated: true, completion: nil)
            }
            
            //
        }
    }

    func handleLogin() {
        print("handle login")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVController = storyboard.instantiateViewController(withIdentifier: "rootController")
        self.present(homeVController, animated: true, completion: nil)

    }

}
