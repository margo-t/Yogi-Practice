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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel.text = UserDefaults.standard.value(forKey: "nickname") as? String
        
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild("email"){
                
                if let value = snapshot.value as? NSDictionary {
                    let email = value["email"] as? String ?? ""
                    self.emailLabel.text = email

            }
            }})
    }
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    //@IBOutlet weak var nicknameLabel: NSLayoutConstraint!
    
    
    @IBAction func logoutBtn(_ sender: Any) {
        
        let logoutPopup = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout?", style: .destructive) { (buttonTapped) in
            do {
                try Auth.auth().signOut()
                
                let defaults = UserDefaults.standard
                defaults.removeObject(forKey:"notifications")
                defaults.removeObject(forKey:"nickname")
                defaults.synchronize()
                
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
