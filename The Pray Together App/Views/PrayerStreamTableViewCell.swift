//
//  PrayerStreamTableViewCell.swift
//  The Pray Together App
//
//  Created by Jason Mundie on 11/4/17.
//  Copyright © 2017 Jason Mundie. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class PrayerStreamTableViewCell: UITableViewCell {
    //    Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var prayerContentLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var prayedForButton: UIButton!
    @IBOutlet weak var prayerCountLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    var streamVC: PrayerStreamViewController?
    
    var prayerPosts: PrayerPosts? {
        didSet {
            updateView()
        }
        
    }
    
    var users: User? {
        didSet {
            setUserInfo()
        }
    }
    
    func updateView() {
        
        prayerContentLabel.text = prayerPosts?.prayer
    }
    
    func setUserInfo() {
        usernameLabel.text = users?.username
        if let photoUrlString = users?.profileImage {
            let photoUrl = URL(string: photoUrlString)
            profileImage.sd_setImage(with: photoUrl, placeholderImage: UIImage(named:"defaultProfileImage"))
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        usernameLabel.text = ""
        
    }
    
    @IBAction func commentButtonTapped(_ sender: Any) {
        commentButtonPressed()
    }
    
    func commentButtonPressed() {
        if let id = prayerPosts?.id {
            streamVC?.performSegue(withIdentifier: "streamToCommentSegue", sender: id)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = UIImage(named: "defaultProfileImage")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
