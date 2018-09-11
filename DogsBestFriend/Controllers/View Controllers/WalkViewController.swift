//
//  WalkViewController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/10/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit
import MapKit

class WalkViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startYourWalkButton: UIButton!
    @IBOutlet weak var pastWalkTableView: UITableView!

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        startYourWalkButton.layer.cornerRadius = 12
        startYourWalkButton.layer.masksToBounds = true
    }

    // MARK: - IBActions
    @IBAction func startYourWalkButtonTapped(_ sender: UIButton) {
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
