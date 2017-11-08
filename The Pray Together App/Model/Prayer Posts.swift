//
//  Prayer Posts.swift
//  The Pray Together App
//
//  Created by Jason Mundie on 11/3/17.
//  Copyright © 2017 Jason Mundie. All rights reserved.
//

import Foundation
import Firebase

class PrayerPosts {
    var prayer: String?
    var username: String?
    var creationDate: Double?
    var sender: String?
    var id: String?
    var prayedForCount: Int?
    var prayedFor: Dictionary <String, Any>?
    var isPrayedFor: Bool?
    
}

extension PrayerPosts {
    static func transformPrayer(dict: [String: Any], key: String) -> PrayerPosts {
        
        let prayerPosts = PrayerPosts()
        
        prayerPosts.id = key
        prayerPosts.prayer = dict["prayer"] as? String
        prayerPosts.username = dict["username"] as? String
        prayerPosts.creationDate = dict["creationDate"] as? Double
        prayerPosts.sender = dict["sender"] as? String
        prayerPosts.prayedForCount = dict["prayedForCount"] as? Int
        prayerPosts.prayedFor = dict["prayedFor"] as? Dictionary <String, Any>
        if let currentUserId = Auth.auth().currentUser?.uid {
        if prayerPosts.prayedFor != nil {
            prayerPosts.isPrayedFor = prayerPosts.prayedFor![currentUserId] != nil
            }
        }
        return prayerPosts
    }
    
}

