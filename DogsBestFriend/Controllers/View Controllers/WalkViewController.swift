//
//  WalkViewController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/10/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import MapKit
import CoreLocation
import UIKit

class WalkViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var startYourWalkButton: UIButton!
    @IBOutlet var pastWalkTableView: UITableView!

    // MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        enableBasicLocationServices()
        startYourWalkButton.layer.cornerRadius = 12
        startYourWalkButton.layer.masksToBounds = true
    }

    // MARK: - IBActions

    @IBAction func startYourWalkButtonTapped(_ sender: UIButton) {}

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
}

// MARK: - Core Locatation Manager Delegate

extension WalkViewController: CLLocationManagerDelegate {
    func enableBasicLocationServices() {
        LocationManager.shared.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            LocationManager.shared.requestWhenInUseAuthorization()
            break
        
        case .restricted, .denied:
//            disableMyLocationBasedFeatures()
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
//            enableMyWhenInUseFeatures()
            break
        }
    }
}
