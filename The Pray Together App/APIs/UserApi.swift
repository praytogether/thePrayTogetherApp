//
//  UserApi.swift
//  The Pray Together App
//
//  Created by Jason Mundie on 11/6/17.
//  Copyright © 2017 Jason Mundie. All rights reserved.
//

import Foundation
import Firebase

class UserApi {
    var REF_USERS = Database.database().reference().child("Users")
    
    func observeUser(withId uid: String, completion: @escaping (User) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict)
                completion(user)
            }
        }
    }
}
    

