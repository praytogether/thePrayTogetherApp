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
    
    override func viewDidLoad() {
        super.viewDidLoad()
commentViewContainer.bindToKeyboard()
      sendButton.isEnabled = false
        handleTextField()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
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
        let ref = Database.database().reference()
        let commentReference = ref.child("Comments")
        let newCommentId = commentReference.childByAutoId().key
        let newCommentReference = commentReference.child(newCommentId)
        guard let currentUser = Auth.auth().currentUser else { return }
        
        let currentUserId = currentUser.uid
        newCommentReference.setValue(["uid": currentUserId, "commentText": commentTextField.text!]) { (error, ref) in
            if error != nil {
                return
            }
            self.empty()
        }
    }
    
    func empty() {
        self.commentTextField.text = ""
        self.sendButton.isEnabled = false
        sendButton.setTitleColor(UIColor.lightGray, for: .normal)
    }
    
}
