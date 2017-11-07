//
//  CommentApi.swift
//  The Pray Together App
//
//  Created by Jason Mundie on 11/6/17.
//  Copyright © 2017 Jason Mundie. All rights reserved.
//

import Foundation
import Firebase

class CommentApi {
    var REF_COMMENTS = Database.database().reference().child("Comments")
    
    func observeComments(withPrayerId id: String, completion: @escaping (Comments) -> Void) {
        REF_COMMENTS.child(id).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let newComment = Comments.transformComment(dict: dict)
                completion(newComment)
            }
        }
    }
}
