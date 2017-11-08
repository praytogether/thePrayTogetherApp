//
//  PrayerStreamViewController.swift
//  The Pray Together App
//
//  Created by Jason Mundie on 10/28/17.
//  Copyright © 2017 Jason Mundie. All rights reserved.
//

import UIKit
import Firebase

class PrayerStreamViewController: UIViewController {
    
    //    OUTLETS
    @IBOutlet weak var prayerStreamTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var prayerPosts = [PrayerPosts]()
    var users = [User]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prayerStreamTableView.estimatedRowHeight = 250
        prayerStreamTableView.rowHeight = UITableViewAutomaticDimension
        prayerStreamTableView.dataSource = self
        loadPrayers()
        
        
    }
    
    
    func loadPrayers() {
        activityIndicator.startAnimating()
        Api.PrayerPost.observePrayers { (prayerPost) in
            guard let prayerPostId = prayerPost.sender else { return }
            self.fetchUser(uid: prayerPostId, completed: {
                self.prayerPosts.append(prayerPost)
                self.activityIndicator.stopAnimating()
                self.prayerStreamTableView.reloadData()
            })
        }
        
    }
    


func fetchUser(uid: String, completed: @escaping () -> Void) {
    Api.User.observeUser(withId: uid) { (user) in
        self.users.append(user)
        completed()
    }
}
    
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignIn")
        self.present(signInVC, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "streamToCommentSegue" {
            let commentVC = segue.destination as! CommentViewController
            let postId = sender as! String
            commentVC.postId = postId
        }
    }
    
}



extension PrayerStreamViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prayerPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = prayerStreamTableView.dequeueReusableCell(withIdentifier: "PrayerStreamCell", for: indexPath) as! PrayerStreamTableViewCell
        let prayerPost = prayerPosts[indexPath.row]
        let user = users[indexPath.row]
        cell.prayerPosts = prayerPost
        cell.users = user
        cell.streamVC = self
        return cell
    }
    
    
}
