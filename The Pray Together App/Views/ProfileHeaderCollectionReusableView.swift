//
//  ProfileHeaderCollectionReusableView.swift
//  The Pray Together App
//
//  Created by Jason Mundie on 11/13/17.
//  Copyright © 2017 Jason Mundie. All rights reserved.
//

import UIKit
import Firebase

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
//  OUTLETS
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var prayerCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    
    var user: User? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
            self.fullNameLabel.text = user!.fullName
            self.usernameLabel.text = user!.username
            if let photoUrlString = user!.profileImage {
                let photoUrl = URL(string: photoUrlString)
                self.profileImage.sd_setImage(with: photoUrl, placeholderImage: UIImage(named:"defaultProfileImage"))
            }
        }
        }


