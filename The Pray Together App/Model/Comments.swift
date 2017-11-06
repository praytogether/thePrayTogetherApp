//
//  Comments.swift
//  The Pray Together App
//
//  Created by Jason Mundie on 11/6/17.
//  Copyright © 2017 Jason Mundie. All rights reserved.
//

import Foundation

class Comments {
    var commentText: String?
    var uid: String?
    
}

extension Comments {
    static func transformComment(dict: [String: Any]) -> Comments {
        
        let comment = Comments()
        
        comment.commentText = dict["commentText"] as? String
        comment.uid = dict["uid"] as? String
        return comment
    }
    
}
