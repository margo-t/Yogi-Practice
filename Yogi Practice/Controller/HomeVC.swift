//
//  HomeVC.swift
//  Yogi Practice
//
//  Created by margot on 2017-09-29.
//  Copyright © 2017 foxberryfields. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func signOutButton(_ sender: Any) {
        
        let logoutPopup = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout?", style: .destructive) { (buttonTapped) in
            do {
                try Auth.auth().signOut()
                let LoginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
                self.present(LoginVC!, animated: true, completion: nil)
            } catch {
                print(error)
            }
        }
        logoutPopup.addAction(logoutAction)
        
        logoutPopup.popoverPresentationController?.sourceView = self.view
        logoutPopup.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        logoutPopup.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)


        
        present(logoutPopup, animated: true, completion: nil)
        
    }
    
    
    

//    @IBAction func signOutButton(_ sender: UIButton) {
//        print("sign out tapped")
//        GIDSignIn.sharedInstance().signOut()
//        do {
//            try
//                Auth.auth().signOut()
//            dismiss(animated: true, completion: nil)
//            performSegue(withIdentifier: "signOut", sender: nil)
//
//        } catch {
//            print("problem logging out")
//        }
//
//    }

}
