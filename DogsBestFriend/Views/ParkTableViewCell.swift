//
//  ParkTableViewCell.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/14/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import MapKit
import UIKit

class ParkTableViewCell: UITableViewCell {
    // MARK: - Properties

    weak var delegate: ParkTableViewCellDelegate?
    var park: Park?

    // MARK: - IBOutlets

    @IBOutlet weak var greyView: UIView!
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var parkAddressLabel: UILabel!
    @IBOutlet weak var favoritesButton: UIButton!

    // MARK: - Life Cycle Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        greyView.layer.cornerRadius = 5
        greyView.layer.masksToBounds = true
    }

    // MARK: - IBActions

    @IBAction func directionsButtonTapped(_ sender: UIButton) {
        delegate?.directionsButtonTapped(self)
    }

    @IBAction func favoriteParkButtonTapped(_ sender: UIButton) {
        delegate?.favoriteButtonTapped(self)
    }
}

// MARK: - Custom Protocol

protocol ParkTableViewCellDelegate: AnyObject {
    func directionsButtonTapped(_ sender: ParkTableViewCell)
    func favoriteButtonTapped(_ sender: ParkTableViewCell)
}
