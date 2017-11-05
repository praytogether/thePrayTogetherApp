//
//  Users.swift
//  The Pray Together App
//
//  Created by Jason Mundie on 11/4/17.
//  Copyright © 2017 Jason Mundie. All rights reserved.
//

import Foundation

class User {
    var email: String?
    var fullName: String?
    var profileImage: String?
    var username: String?
}
extension User {
    static func transformUser(dict: [String: Any]) -> User {
        let user = User()
        user.email = dict["email"] as? String
        user.fullName = dict["fullName"] as? String
        user.profileImage = dict["profileImage"] as? String
        user.username = dict["username"] as? String
        
        return user
    }
}
