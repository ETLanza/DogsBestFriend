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

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var cancelWalkButton: UIBarButtonItem!
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
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        walk = nil
    }
    
    @IBAction func startYourWalkButtonTapped(_ sender: UIButton) {
        startWalk()
        cancelWalkButton.title = ""
        cancelWalkButton.isEnabled = false
    }

    @IBAction func stopYourWalkButtonTapped(_ sender: UIButton) {
        displayStopWalkAlert()
    }

    // MARK: - Helper Methods

    func setUpViews() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        locationManager.delegate = self
        mapView.layer.cornerRadius = 5
        mapView.layer.masksToBounds = true
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
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.removeOverlays(mapView.overlays)

        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        updateLabels()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
        locationList.append(locationManager.location!)
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
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.allowsBackgroundLocationUpdates = true
    }

    func displayStopWalkAlert() {
        var alertTitle: String = "Nice Walk"
        if seconds > 300 {
            alertTitle = "Great Walk!"
        }
        let stopWalkAlertController = UIAlertController(title: alertTitle, message: "Do you want to save this walk?", preferredStyle: .actionSheet)
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
                var locations: [Location] = []
                for loc in self.locationList {
                    let location = Location(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude, timestamp: loc.timestamp)
                    locations.append(location)
                }
                
                WalkController.shared.add(locations: locations, toWalk: walk, completion: { (success) in
                    if success {
                        WalkController.shared.saveWalkToFirebase(walk: walk, completion: { (success) in
                            if success {
                                DBFUserController.shared.add(walk: walk, completion: { (success) in
                                    if success {
                                        self.dismissSelf()
                                    }
                                })
                            }
                        })
                    }
                })                
            }
        }
    }
    
    func dismissSelf() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
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
                mapView.addOverlay(MKGeodesicPolyline(coordinates: coordinates, count: 2))
                let region = MKCoordinateRegion(center: newLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                mapView.setRegion(region, animated: true)
            }
            locationList.append(newLocation)
        }
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager failed with error: \(error.localizedDescription).")
    }
}

// MARK: - Map View Delegate

extension NewWalkViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKGeodesicPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 5
        return renderer
    }
}
