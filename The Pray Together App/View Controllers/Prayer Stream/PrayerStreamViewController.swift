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
        
//        var prayerPosts = PrayerPosts(prayerText: "Test")
    }
    
    
    
    func loadPrayers() {
        activityIndicator.stopAnimating()
        Database.database().reference().child("Prayer Posts").observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let newPrayer = PrayerPosts.transformPrayer(dict: dict)
                self.fetchUser(uid: newPrayer.sender!, completed: {
                self.prayerPosts.append(newPrayer)
                    self.activityIndicator.stopAnimating()
                self.prayerStreamTableView.reloadData()
                print(dict)
            })
            }
        }
    }
    
    func fetchUser(uid: String, completed: @escaping () -> Void ) {
        Database.database().reference().child("Users").child(uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict)
              self.users.append(user)
                completed()
            }
        })
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
        return cell
    }
    
    
}
