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
    
    var REF_BASE: DatabaseReference{
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference{
        return _REF_USERS
    }
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>){
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func updateMeditationTime(withTime time: Int, andTotalTime totalTime: Int, forUid: String, forDay: String, sendComplete: @escaping(_ status: Bool)->()) {
        
        REF_USERS.child(forUid).child("meditation").child("history").child(forDay).childByAutoId().updateChildValues(["sessionTime": time])
        REF_USERS.child(forUid).child("meditation").updateChildValues(["totalTime" : totalTime])
        sendComplete(true)
    }
    

}
