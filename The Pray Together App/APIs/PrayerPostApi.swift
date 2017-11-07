//
//  PrayerPostApi.swift
//  The Pray Together App
//
//  Created by Jason Mundie on 11/6/17.
//  Copyright © 2017 Jason Mundie. All rights reserved.
//

import Foundation
import Firebase

class PrayerPostApi {
    var REF_PRAYERPOSTS = Database.database().reference().child("Prayer Posts")
    
    func observePrayers(completion: @escaping (PrayerPosts) -> Void) {
        REF_PRAYERPOSTS.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let newPrayer = PrayerPosts.transformPrayer(dict: dict, key: snapshot.key)
                completion(newPrayer)
            }
        }
    }
}
