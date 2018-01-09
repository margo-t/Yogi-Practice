//
//  SettingsVC.swift
//  Yogi Practice
//
//  Created by margot on 2017-12-08.
//  Copyright © 2017 foxberryfields. All rights reserved.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {
    
    @IBAction func logoutBtn(_ sender: Any) {
        
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
    

}
