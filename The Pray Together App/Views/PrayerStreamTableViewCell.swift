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
    @IBOutlet weak var prayedForCountButton: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    
    var streamVC: PrayerStreamViewController?
    var prayerRef: DatabaseReference!
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
        
        Api.PrayerPost.REF_PRAYERPOSTS.child(prayerPosts!.id!).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let prayerPost = PrayerPosts.transformPrayer(dict: dict, key: snapshot.key)
            self.updatePrayedFor(prayerPosts: prayerPost)
        }
    })
        Api.PrayerPost.REF_PRAYERPOSTS.child(prayerPosts!.id!).observe(.childChanged, with: {
            snapshot in
            guard let value = snapshot.value as? Int else { return }
                if value >= 2 {
                    self.prayedForCountButton.setTitle("\(value) people have prayed for this", for: .normal)
                } else if value == 1 {
                    self.prayedForCountButton.setTitle("\(value) person has prayed for this", for: .normal)
                } else {
                        self.prayedForCountButton.setTitle("Be the first to pray for this", for: .normal)
                }
        })
    }
    
    func updatePrayedFor(prayerPosts: PrayerPosts) {
        let imageName = prayerPosts.prayedFor == nil || !prayerPosts.isPrayedFor! ? "prayedForUnselected" : "prayedForselected1"
        prayedForButton.setImage(UIImage(named: imageName), for: .normal)
        guard let count = prayerPosts.prayedForCount else { return }
        if count >= 2 {
            prayedForCountButton.setTitle("\(count) people have prayed for this", for: .normal)
        } else if count == 1 {
            prayedForCountButton.setTitle("\(count) person has prayed for this", for: .normal)
        } else {
            prayedForCountButton.setTitle("Be the first to pray for this", for: .normal)
        }
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
    
    @IBAction func prayedForButtonTapped(_ sender: Any) {
        prayedForButtonPressed()
    }
    
    func prayedForButtonPressed() {
        prayerRef = Api.PrayerPost.REF_PRAYERPOSTS.child(prayerPosts!.id!)
        incrementPrayedFor(forRef: prayerRef)
    }
    
    func incrementPrayedFor(forRef ref: DatabaseReference) {
        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = Auth.auth().currentUser?.uid {
                var prayedFor: Dictionary<String, Bool>
                prayedFor = post["prayedFor"] as? [String : Bool] ?? [:]
                var prayedForCount = post["prayedForCount"] as? Int ?? 0
                if let _ = prayedFor[uid] {
                    
                    prayedForCount -= 1
                    prayedFor.removeValue(forKey: uid)
                } else {
                   
                    prayedForCount += 1
                    prayedFor[uid] = true
                }
                post["prayedForCount"] = prayedForCount as AnyObject?
                post["prayedFor"] = prayedFor as AnyObject?
                

                currentData.value = post
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let dict = snapshot?.value as? [String: Any] {
                let prayerPost = PrayerPosts.transformPrayer(dict: dict, key: snapshot!.key)
                self.updatePrayedFor(prayerPosts: prayerPost)
            }
        }
    }
    
    @IBAction func bookmarkButtonTapped(_ sender: Any) {
        bookmarkButtonPressed()
    }
    
    func bookmarkButtonPressed() {
        print("pressed")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = UIImage(named: "defaultProfileImage")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
}
