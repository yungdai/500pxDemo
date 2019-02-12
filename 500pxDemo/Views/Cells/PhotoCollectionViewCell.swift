//
//  PhotoCollectionViewCell.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-11.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet weak var mainLabel: UILabel!
	
	override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: .none)
	}
	
	
//     TODO: Impliment later to reset anything in the cell as it comes in and out of the collectionView
    override func awakeFromNib() {
        super.awakeFromNib()

        configure(with: .none)
    }
	
	func configure(with photo: Photo?) {
		
		if let photo = photo {
			
			// TODO: Change this to make it prettier and use different data later
			mainLabel.alpha = 1
			mainLabel.text =  photo.name
		} else {
			mainLabel.alpha = 0
		}
	}
}
