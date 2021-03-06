//
//  PhotoCollectionViewCell.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-11.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import UIKit

final class PhotoCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var autherNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
	override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: .none)
	}

    override func awakeFromNib() {
        super.awakeFromNib()
        configure(with: .none)
    }
	
	func configure(with photo: Photo?) {
		
		if let photo = photo {

			mainLabel.alpha = 1
            avatar.alpha = 1
            autherNameLabel.alpha = 1

            if let imageURLString = photo.images.first?.urlString {
                image.getImage(from: URL(string: imageURLString)!)
            }

            if let avatarURLString = photo.user.avatars.smallURLString["https"] {
                avatar.getImage(from: URL(string: avatarURLString)!)
            }
            
            avatar.convertToCircle()

            autherNameLabel.text = photo.user.fullName
			mainLabel.text =  photo.name
            
            // round corners of the cell to make it a little bit softer
            self.contentView.layer.cornerRadius = 20
            self.contentView.layer.masksToBounds = true
		} else {
            
			mainLabel.alpha = 0
            avatar.alpha = 0
            autherNameLabel.alpha = 0
		}
	}
}
