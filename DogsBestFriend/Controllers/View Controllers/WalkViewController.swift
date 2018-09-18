//
//  WalkViewController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/10/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import MapKit
import UIKit

class WalkViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var startYourWalkButton: UIButton!
    @IBOutlet var pastWalkTableView: UITableView!

    // MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }

    // MARK: - IBActions

    @IBAction func startYourWalkButtonTapped(_ sender: UIButton) {}

    // MARK: - Helper Methods

    func setUpViews() {
        startYourWalkButton.layer.cornerRadius = 12
        startYourWalkButton.layer.masksToBounds = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
}
