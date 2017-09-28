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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        googleSignInButton.style = .wide
        
        GIDSignIn.sharedInstance().signIn()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            handleLogin()
        }
    }
    
    func handleLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let meditationVController: MeditationVC = (storyboard.instantiateViewController(withIdentifier: "MeditationVC") as? MeditationVC)!
        
        self.present(meditationVController, animated: true, completion: nil)
        
        //self.present(meditationVController, animated: true, complition: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
