//
//  HomePageTableViewCell.swift
//  InstaSearch
//
//  Created by admin on 02.07.17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit

class MediaViewCell: UICollectionViewCell {
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd MMMM yyyy"
        return df
    }()
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.zeroSymbol = "–"
        return nf
    }()
    
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var nickname: UILabel!
    @IBOutlet var content: UIImageView!
    
    @IBOutlet var likesCounter: UILabel!
    @IBOutlet var commentsCounter: UILabel!
    
    @IBOutlet var bookmarkBtn: UIButton!
    
    @IBOutlet var likeBtn: UIImageView!
    
    
    @IBOutlet var publicDate: UILabel!
 
    func setup(media: Media)  {
        nickname.text = media.user?.username
        
        let profilePictureURL = URL(string: media.user!.profilePicture)
        avatar.sd_setImage(with: profilePictureURL)
        
        let imageURL = URL(string: media.imageURL)
        content.sd_setImage(with: imageURL)
        
        likesCounter.text = numberFormatter.string(from: media.likesCount as NSNumber)
        if media.likesCount >= 1 {
            likeBtn.image = #imageLiteral(resourceName: "like_btn_hl")
        } else {
            likeBtn.image = #imageLiteral(resourceName: "like_btn")
        }
        
        commentsCounter.text = numberFormatter.string(from: media.commentsCount as NSNumber)
        
        let date = Date(timeIntervalSince1970: TimeInterval(atof(media.createdTime)))
        
        publicDate.text = dateFormatter.string(from: date).uppercased()
    }
    
}
