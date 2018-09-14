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
    var placemark: MKPlacemark?

    // MARK: - IBOutlets

    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var favoritesButton: UIButton!

    // MARK: - Life Cycle Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - IBActions

    @IBAction func parkDetailsButtonTapped(_ sender: UIButton) {
        delegate?.parkDetailsButtonTapped(self)
    }

    @IBAction func directionsButtonTapped(_ sender: UIButton) {
        delegate?.directionsButtonTapped(self)
    }

    @IBAction func favoriteParkButtonTapped(_ sender: UIButton) {
        delegate?.favoriteButtonTapped(self)
    }
}

protocol ParkTableViewCellDelegate: AnyObject {
    func parkDetailsButtonTapped(_ sender: ParkTableViewCell)
    func directionsButtonTapped(_ sender: ParkTableViewCell)
    func favoriteButtonTapped(_ sender: ParkTableViewCell)
}
