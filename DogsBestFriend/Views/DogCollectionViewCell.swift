//
//  DogCollectionViewCell.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/14/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class DogCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    
    var dog: Dog?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var dogProfilePicture: UIImageView!
    @IBOutlet weak var dogNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dogProfilePicture.layer.cornerRadius = dogProfilePicture.frame.height / 2
        dogProfilePicture.layer.masksToBounds = true
    }
}
