//
//  ProfileViewController.swift
//  The Pray Together App
//
//  Created by Jason Mundie on 10/28/17.
//  Copyright © 2017 Jason Mundie. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
//OUTLETS
    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       profileCollectionView.dataSource = self
        fetchUser()
    }

    func fetchUser() {
        Api.User.observeCurrentUser { (user) in
           self.user = user
            self.profileCollectionView.reloadData()
        }
    }
    }
    


extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrayerCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ProfileHeader", for: indexPath) as! ProfileHeaderCollectionReusableView
        if let user = self.user {
             headerViewCell.user = user 
        }
       
        return headerViewCell
    }
    
}
