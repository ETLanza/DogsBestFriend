//
//  ParkDetailViewController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/12/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import MapKit
import UIKit

class ParkDetailViewController: UIViewController {
    // MARK: - Properties

    var placemark: MKPlacemark?

    // MARK: - IBOutlets

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var parkAddressLabel: UILabel!

    // MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        placemark?.areasOfInterest?.forEach { print($0) }
    }

    // MARK: - IBActions

    @IBAction func doneButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Helper Methods

    func setUpViews() {
        parkNameLabel.text = placemark?.name
        parkAddressLabel.text = AddressFormatter.shared.parseAddress(selectedItem: placemark!)
        popUpView.layer.cornerRadius = 20
        popUpView.clipsToBounds = true
    }
}
