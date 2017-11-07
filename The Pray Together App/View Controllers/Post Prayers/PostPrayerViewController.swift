//
//  PostPrayerViewController.swift
//  The Pray Together App
//
//  Created by Jason Mundie on 10/28/17.
//  Copyright © 2017 Jason Mundie. All rights reserved.
//

import UIKit
import Firebase

class PostPrayerViewController: UIViewController {
    
    //    OUTLETS
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var prayerTextView: UITextView!
    @IBOutlet weak var groupsTextField: UITextField!
    @IBOutlet weak var organizationsTextField: UITextField!
    
    @IBOutlet weak var facebookLabel: UILabel!
    @IBOutlet weak var facebookSwitch: UISwitch!
    @IBOutlet weak var postPrayerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prayerTextView.delegate = self as! UITextViewDelegate
        postPrayerButton.bindToKeyboard()
        hideKeyboardWhenTappedAround()
        
    }
    @IBAction func postPrayerButtonTapped(_ sender: Any) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child(uid)
        
        Database.database().reference().child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            
            guard let username = dictionary["username"] as? String else { return }
            
            if self.prayerTextView.text != nil && self.prayerTextView.text != "Post prayer here..." {
                self.postPrayerButton.isEnabled = false
                
                DataService.instance.uploadPost(withMessage: self.prayerTextView.text, forUID: uid, withUsername:username , withGroupKey: nil, withCreationDate: Date().timeIntervalSince1970, sendComplete: { (isComplete) in
                    if isComplete {
                        self.postPrayerButton.isEnabled = true
                        self.tabBarController?.selectedIndex = 0
                        self.prayerTextView.text = "Post prayer here..."
                    } else {
                        print("error posting")
                    }
                })
            }
        }
        )}
}

extension PostPrayerViewController: UITextViewDelegate {
    func textViewDidBeginEditing (_ textView: UITextView) {
        prayerTextView.text = ""
    }
}
