//
//  LoginVC.swift
//  Yogi Practice
//
//  Created by margot on 2017-09-27.
//  Copyright © 2017 foxberryfields. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn;

class LoginVC: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    @IBAction func loginEmailButton(_ sender: Any) {
        let signUpVC = storyboard?.instantiateViewController(withIdentifier: "SignUpVC")
        present(signUpVC!, animated: true, completion: nil)
    }
    @IBAction func loginFbButton(_ sender: Any) {
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().signIn()
//        googleSignInButton.style = .wide
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
        }
    }

    func handleLogin() {
        print("handle login")
          //performSegue(withIdentifier: "login", sender: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let meditationVController: MeditationVC = (storyboard.instantiateViewController(withIdentifier: "MeditationVC") as? MeditationVC)!
        self.present(meditationVController, animated: true, completion: nil)

    }

}
