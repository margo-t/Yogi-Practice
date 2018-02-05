//
//  SignUpVC.swift
//  Yogi Practice
//
//  Created by margot on 2017-09-27.
//  Copyright © 2017 foxberryfields. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn;

class SignUpVC: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    @IBAction func closePopupBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var notificationView: DesignableView!
    @IBOutlet weak var notificationLabel: UITextView!
    
    
    @IBAction func signInButton(_ sender: UIButton) {
        
        signInAction()
        
    }
    
    func signInAction(){
        
        passwordField.resignFirstResponder()
        
        notificationView.isHidden = true
        notificationLabel.isHidden = true
        
        if emailField.text != nil && passwordField.text != nil {
            AuthService.instance.loginUser(withEmail: emailField.text!, andPassword: passwordField.text!, loginComplete: { (success, loginError) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                    
                    self.notificationView.isHidden = true
                    self.notificationLabel.isHidden = true
                }
                    
                else {
                    print(String(describing: loginError?.localizedDescription))
                    
                    self.notificationView.isHidden = false
                    self.notificationLabel.isHidden = false
                    
                    self.notificationLabel.text = loginError?.localizedDescription
                    
                    
                }
                
                AuthService.instance.registerUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, userCreationComplete: { (success, registrationError) in
                    if success {
                        AuthService.instance.loginUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, loginComplete: { (success, nil) in
                            self.dismiss(animated: true, completion: nil)
                            print("Successfully registered user")
                            
                            self.notificationView.isHidden = true
                            self.notificationLabel.isHidden = true
                        })
                    } else {
                        print(String(describing: registrationError?.localizedDescription))
                        
                        self.notificationView.isHidden = false
                        self.notificationLabel.isHidden = false
                        
                        self.notificationLabel.text = (registrationError?.localizedDescription)!
                    }
                })
                
            })
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationView.isHidden = true
        notificationLabel.isHidden = true
        
        emailField.delegate = (self as UITextFieldDelegate)
        passwordField.delegate = (self as UITextFieldDelegate)
    }

}

extension SignUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailField {
            self.passwordField.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
            signInAction()
            
        }
        return true
    }
}
