//
//  Onboarding2VC.swift
//  Yogi Practice
//
//  Created by margot on 2018-06-23.
//  Copyright © 2018 foxberryfields. All rights reserved.
//

import UIKit
import Firebase;

class Onboarding2VC: UIViewController {
    
    let colorGreen = UIColor(red: 36/255, green: 136/255, blue: 136/255, alpha: 1.00)
    let colorPink = UIColor(red: 246/255, green: 65/255, blue: 108/255, alpha: 1.00)
    
    
    var enabledNotifications = false;
    var signupForNews = false;
    var language = "eng";
    

    @IBOutlet weak var notificationsOutlet: UIButton!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var finishOutlet: UIButton!
    @IBOutlet weak var signUpOutlet: UIButton!
    @IBOutlet weak var languageOutlet: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nicknameTextField.delegate = self
        
    }
    
    @IBAction func languageAction(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex{
        case 0:
            language = "eng";
            print(enabledNotifications)
        case 1:
            language = "fr";
            print(enabledNotifications)
        default:
            language = "eng";
            break
        }
        
    }
    
    
    @IBAction func enableButton(_ sender: UIButton) {
        
        if !enabledNotifications {
            enabledNotifications = true
            notificationsOutlet.setTitle("✔ Notifications Enabled", for: .normal)
            notificationsOutlet.setTitleColor(colorGreen, for: .normal) // set it to green
            
        }
        else {
            enabledNotifications = false
            notificationsOutlet.setTitle("Enable notifications", for: .normal)
            notificationsOutlet.setTitleColor(colorPink, for: .normal)
            
        }
    }
    
    @IBAction func signupButton(_ sender: UIButton) {
        
        if !signupForNews {
            signupForNews = true
            signUpOutlet.setTitle("✔ Signed Up", for: .normal)
            signUpOutlet.setTitleColor(colorGreen, for: .normal) // set it to green
            languageOutlet.isHidden = false
            

        }
        else {
            signupForNews = false
            signUpOutlet.setTitle("Select to sign up", for: .normal)
            signUpOutlet.setTitleColor(colorPink, for: .normal)
            languageOutlet.isHidden = true
        }

        
    }
    
    
    
    
    @IBAction func finishButton(_ sender: UIButton) {
        
        if nicknameTextField?.text != nil && nicknameTextField?.text != "" {
            self.finishOutlet.isEnabled = false
            let nickname = nicknameTextField?.text
            let userID = Auth.auth().currentUser?.uid
            
            //save to firebase
            DataService.instance.saveUserInfo(withNickname: nickname!, forUid: userID!, forPref:signupForNews, withLang: language, sendComplete: {(isComplete) in
                if isComplete {
                    self.finishOutlet.isEnabled = true
                    print("sent to Firebase")
                    
                }
                else {
                    self.finishOutlet.isEnabled = true
                    print("Error sending")
                }
            })
            
            //update user defaults
            UserDefaults.standard.set(nickname, forKey: "nickname")
            UserDefaults.standard.set(enabledNotifications, forKey: "notifications")
        }
    }
    
    
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "completeOnboarding" {
            if nicknameTextField?.text == nil || nicknameTextField?.text == "" {
                let alertController = UIAlertController(
                    title: "Nickname missing",
                    message: "Please enter a nickname to complete",
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(title: "Ok", style: .default , handler: nil))
                
                present(alertController, animated: true, completion: nil)
                return false
            }
        }
        
        return true
    }
    

    
}

extension Onboarding2VC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
