//
//  Prayer Posts.swift
//  The Pray Together App
//
//  Created by Jason Mundie on 11/3/17.
//  Copyright © 2017 Jason Mundie. All rights reserved.
//

import Foundation

class PrayerPosts {
    var prayer: String?
    var username: String?
    var creationDate: Double?
    var sender: String?
    
}

extension PrayerPosts {
    static func transformPrayer(dict: [String: Any]) -> PrayerPosts {
    
    let prayerPosts = PrayerPosts()
    
    prayerPosts.prayer = dict["prayer"] as? String
    prayerPosts.username = dict["username"] as? String
    prayerPosts.creationDate = dict["creationDate"] as? Double
    prayerPosts.sender = dict["sender"] as? String
    return prayerPosts
}

}
