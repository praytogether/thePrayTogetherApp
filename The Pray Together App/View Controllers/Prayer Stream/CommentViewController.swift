//
//  CommentViewController.swift
//  The Pray Together App
//
//  Created by Jason Mundie on 11/6/17.
//  Copyright © 2017 Jason Mundie. All rights reserved.
//

import UIKit
import Firebase

class CommentViewController: UIViewController {
    //OUTLETS
    @IBOutlet weak var commentViewContainer: UIView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var commentTableView: UITableView!
    
    var postId: String!
    var comments = [Comments]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Comment"
        commentTextField.bindToKeyboard()
        sendButton.bindToKeyboard()
        hideKeyboardWhenTappedAround()
        sendButton.isEnabled = false
        handleTextField()
        loadComments()
        commentTableView.dataSource = self
        commentTableView.estimatedRowHeight = 80
        commentTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func loadComments() {
        Api.Post_Comment.REF_POSTCOMMENTS.child(self.postId).observe(.childAdded, with: { snapshot in
            
            Api.Comment.observeComments(withPrayerId: snapshot.key, completion: { (comment) in
                self.fetchUser(uid: comment.uid!, completed: {
                    self.comments.append(comment)
                    self.commentTableView.reloadData()
            })
            
        })
    })
}
    
    func fetchUser(uid: String, completed: @escaping () -> Void ) {
        Api.User.observeUser(withId: uid) { (user) in
            self.users.append(user)
            completed()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func handleTextField() {
        commentTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    @objc func textFieldDidChange() {
        if let commentText = commentTextField.text, !commentText.isEmpty {
            sendButton.setTitleColor(#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), for: .normal)
            sendButton.isEnabled = true
            return
        }
        sendButton.setTitleColor(UIColor.lightGray, for: .normal)
        sendButton.isEnabled = false
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        
        let commentReference = Api.Comment.REF_COMMENTS
        let newCommentId = commentReference.childByAutoId().key
        let newCommentReference = commentReference.child(newCommentId)
        guard let currentUser = Auth.auth().currentUser else { return }
        
        let currentUserId = currentUser.uid
        newCommentReference.setValue(["uid": currentUserId, "commentText": commentTextField.text!]) { (error, ref) in
            if error != nil {
                return
            }
            
            let postCommentRef = Api.Post_Comment.REF_POSTCOMMENTS.child(self.postId).child(newCommentId)
            postCommentRef.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    print("failed to post comment \(error)")
                    return
                }
            })
            self.empty()
        }
    }
    
    func empty() {
        self.commentTextField.text = ""
        self.sendButton.isEnabled = false
        sendButton.setTitleColor(UIColor.lightGray, for: .normal)
    }
}


extension CommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentTableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentsTableViewCell
        let comment = comments[indexPath.row]
        let user = users[indexPath.row]
        cell.comment = comment
        cell.users = user
        return cell
    }
}
