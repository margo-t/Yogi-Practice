//
//  DataService.swift
//  Yogi Practice
//
//  Created by margot on 2017-09-28.
//  Copyright © 2017 foxberryfields. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_MEDITATION = DB_BASE.child("meditation")
    private var _REF_PRACTICE = DB_BASE.child("practice")
    private var _REF_MAILING = DB_BASE.child("mailingList")
    
    var REF_BASE: DatabaseReference{
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference{
        return _REF_USERS
    }
    
    var REF_MAILING: DatabaseReference{
        return _REF_MAILING
    }
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>){
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func updateMeditationTime(withTime time: Int, andTotalTime totalTime: Int, forUid: String, toRef: String, forDay: String, sendComplete: @escaping(_ status: Bool)->()) {
        
        if toRef=="meditation" {
        
        REF_USERS.child(forUid).child("meditation").child("history").child(forDay).childByAutoId().updateChildValues(["sessionTime": time])
        REF_USERS.child(forUid).child("meditation").updateChildValues(["totalTime" : totalTime])
        sendComplete(true)
            
        }
        
        else if toRef=="practice" {
            
            REF_USERS.child(forUid).child("practice").child("history").child(forDay).childByAutoId().updateChildValues(["sessionTime": time])
            REF_USERS.child(forUid).child("practice").updateChildValues(["totalTime" : totalTime])
            sendComplete(true)
        }
    }
    
    func saveUserInfo(withNickname name: String, forUid: String, forPref preference: Bool, withLang language: String, sendComplete: @escaping(_ status: Bool)->()) {
        
        REF_USERS.child(forUid).child("userInfo").updateChildValues(["nickname" : name])
        
        if preference {
            
            let now = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "LLLL-YYYY"
            let period = dateFormatter.string(from: now)
            
            let userID = Auth.auth().currentUser?.uid
            let ref = Database.database().reference()
            ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.hasChild("email"){
                    
                    if let value = snapshot.value as? NSDictionary {
                        let email = value["email"] as? String ?? ""
                        self.REF_MAILING.child(period).child(language).childByAutoId().setValue(email)}
                    sendComplete(true)
                }
            })
            
        }
        else {
            sendComplete(true)
        }
        
    }
    
    func saveMailingAddress(forPref preference: Bool, withLang language: String, sendComplete: @escaping(_ status: Bool)->()) {
        
        if preference {
            
            let now = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "LLLL-YYYY"
            let period = dateFormatter.string(from: now)
            
            let userID = Auth.auth().currentUser?.uid
            let ref = Database.database().reference()
            ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.hasChild("email"){
                    
                    if let value = snapshot.value as? NSDictionary {
                        let email = value["email"] as? String ?? ""
                        self.REF_MAILING.child(period).updateChildValues([language : email])}
                }
            })
            sendComplete(true)
        }
        else {
            sendComplete(true)
        }
    }
    

}
