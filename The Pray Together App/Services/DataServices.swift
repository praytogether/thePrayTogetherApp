//
//  DataServices.swift
//  The Pray Together App
//
//  Created by Jason Mundie on 10/30/17.
//  Copyright © 2017 Jason Mundie. All rights reserved.
//

import UIKit
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("Users")
    private var _REF_GROUPS = DB_BASE.child("Groups")
    private var _REF_ORGANIZATIONS = DB_BASE.child("Organizations")
    private var _REF_STREAM = DB_BASE.child("Prayer Posts")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    
    var REF_ORGANIZATIONS: DatabaseReference {
        return _REF_ORGANIZATIONS
    }
    
    var REF_STREAM: DatabaseReference {
        return _REF_STREAM
    }
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
}
    
    func uploadPost(withMessage message: String, forUID uid: String, withUsername username: String, withGroupKey groupKey: String?, withCreationDate creationDate: Double, sendComplete: @escaping (_ status: Bool) -> ()) {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        
        if groupKey != nil {
            REF_GROUPS.child(groupKey!).child("Prayer Body").childByAutoId().updateChildValues(["prayer": message, "sender": uid, "username": username])
            sendComplete(true)
        } else {
            REF_STREAM.childByAutoId().updateChildValues(["prayer": message, "sender": uid, "username": username, "creationDate": Date().timeIntervalSince1970])
            sendComplete(true)
            
//            REF_STREAM.child(userUid).childByAutoId().updateChildValues(["prayer": message, "sender": uid, "username": username, "creationDate": Date().timeIntervalSince1970])
//            sendComplete(true)
        }
    }
    
}
