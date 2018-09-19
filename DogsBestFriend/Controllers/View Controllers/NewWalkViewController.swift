//
//  NewWalkViewController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/19/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import MapKit
import UIKit

class NewWalkViewController: UIViewController {
    // MARK: - Properties

    var walk: Walk?
    let locationManager = LocationManager.shared
    var seconds = 0
    var timer: Timer?
    var distance = Measurement(value: 0, unit: UnitLength.meters)
    var locationList: [CLLocation] = []

    // MARK: - IBOutlets

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startYourWalkButton: UIButton!
    @IBOutlet weak var stopYourWalkButton: UIButton!
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    // MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }

    // MARK: - IBActions

    @IBAction func startYourWalkButtonTapped(_ sender: UIButton) {
        startWalk()
    }

    @IBAction func stopYourWalkButtonTapped(_ sender: UIButton) {
        displayStopWalkAlert()
    }

    // MARK: - Helper Methods

    func setUpViews() {
        locationManager.delegate = self
         startYourWalkButton.layer.cornerRadius = 12
        startYourWalkButton.layer.masksToBounds = true
        stopYourWalkButton.layer.cornerRadius = 12
        stopYourWalkButton.layer.masksToBounds = true
        mapView.layer.cornerRadius = 12
        mapView.layer.masksToBounds = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.setRegion(MKCoordinateRegion(center: CLLocationManager().location!.coordinate, latitudinalMeters: 500, longitudinalMeters: 500), animated: true)
        }
    }

    func eachSecond() {
        seconds += 1
        updateLabels()
    }

    func updateLabels() {
        let formattedDistance = DisplayFormatter.distance(distance)
        let formattedTime = DisplayFormatter.time(seconds)

        distanceLabel.text = "\(formattedDistance)"
        timeLabel.text = "\(formattedTime)"
    }

    func startWalk() {
        dataView.isHidden = false
        startYourWalkButton.isHidden = true
        stopYourWalkButton.isHidden = false
        mapView.removeOverlays(mapView.overlays)

        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        updateLabels()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
        startLocationUpdates()
    }

    func stopWalk() {
        timer?.invalidate()
        dataView.isHidden = true
        startYourWalkButton.isHidden = false
        stopYourWalkButton.isHidden = true
        locationManager.stopUpdatingLocation()
    }

    func startLocationUpdates() {
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }

    func displayStopWalkAlert() {
        let stopWalkAlertController = UIAlertController(title: "End run?", message: "Do you wish to end your run?", preferredStyle: .actionSheet)
        let saveAction = UIAlertAction(title: "Save Walk", style: .default) { _ in
            self.stopWalk()
            self.saveWalk()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let dontSaveAction = UIAlertAction(title: "Don't Save Walk", style: .destructive) { _ in
            self.stopWalk()
            self.dismiss(animated: true, completion: nil)
        }
        stopWalkAlertController.addAction(saveAction)
        stopWalkAlertController.addAction(dontSaveAction)
        stopWalkAlertController.addAction(cancelAction)

        present(stopWalkAlertController, animated: true)
    }

    func saveWalk() {
        WalkController.shared.createNewWalk(distance: distance.value, timestamp: Date(), duration: seconds, locations: []) { walk in
            if let walk = walk {
                for location in self.locationList {
                    let locationObject = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, timestamp: location.timestamp)
                    WalkController.shared.add(location: locationObject, toWalk: walk)
                }
                WalkController.shared.walks.append(walk)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}

// MARK: - Location Manager Delegate

extension NewWalkViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }

            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
                mapView.addOverlay(MKPolyline(coordinates: coordinates, count: 2))
                let region = MKCoordinateRegion(center: newLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                mapView.setRegion(region, animated: true)
            }
            locationList.append(newLocation)
        }
    }
}

// MARK: - Map View Delegate

extension NewWalkViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3
        return renderer
    }
}