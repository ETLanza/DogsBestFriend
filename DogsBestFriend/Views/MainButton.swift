//
//  MainButton.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 4/23/19.
//  Copyright © 2019 ETLanza. All rights reserved.
//

import UIKit

class MainButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tintColor = UIColor(named: "mainColor")
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
}
