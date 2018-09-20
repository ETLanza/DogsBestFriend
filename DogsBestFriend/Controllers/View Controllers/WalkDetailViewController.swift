//
//  WalkDetailViewController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/12/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import MapKit
import UIKit

class WalkDetailViewController: UIViewController {
    // MARK: - Properties

    var walk: Walk!

    // MARK: - IBOutlets

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }

    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Helper Methods
    func setUpViews() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.title = DisplayFormatter.dayOfTheWeek(walk.timestamp) + " Walk"
        mapView.layer.cornerRadius = 12
        mapView.layer.masksToBounds = true
        dayLabel.text = DisplayFormatter.date(walk.timestamp)
        durationLabel.text = DisplayFormatter.time(walk.duration)
        distanceLabel.text = DisplayFormatter.distance(walk.distance)
        loadMap()
    }

    func mapRegion() -> MKCoordinateRegion? {
        guard walk.locations.count > 0 else { return nil }

        let latitudes = walk.locations.map { location -> Double in
            return location.latitude
        }

        let longitudes = walk.locations.map { location -> Double in
            return location.longitude
        }

        let maxLat = latitudes.max()!
        let minLat = latitudes.min()!
        let maxLong = longitudes.max()!
        let minLong = longitudes.min()!

        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                            longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                                    longitudeDelta: (maxLong - minLong) * 1.3)
        return MKCoordinateRegion(center: center, span: span)
    }

    func polyLine() -> [MKPolyline] {

        let locations = walk.locations
        var coordinates: [(CLLocation, CLLocation)] = []
        var speeds: [Double] = []
        var minSpeed = Double.greatestFiniteMagnitude
        var maxSpeed = 0.0

        for (first, second) in zip(locations, locations.dropFirst()) {
            let start = CLLocation(latitude: first.latitude, longitude: first.longitude)
            let end = CLLocation(latitude: second.latitude, longitude: second.longitude)
            coordinates.append((start, end))

            let distance = end.distance(from: start)
            let time = second.timestamp.timeIntervalSince(first.timestamp as Date)
            let speed = time > 0 ? distance / time : 0
            speeds.append(speed)
            minSpeed = min(minSpeed, speed)
            maxSpeed = max(maxSpeed, speed)
        }

        var segments: [MKPolyline] = []
        for ((start, end), _) in zip(coordinates, speeds) {
            let coords = [start.coordinate, end.coordinate]
            let segment = MKPolyline(coordinates: coords, count: 2)
            segments.append(segment)
        }
        return segments
    }

    func loadMap() {
        guard walk.locations.count > 0, let region = mapRegion() else {
            let alert = UIAlertController(title: "Error", message: "Sorry, this run has no locations saved", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert, animated: true)
            return
        }
        mapView.setRegion(region, animated: true)
        mapView.addOverlays(polyLine())
    }
}

// MARK: - Map View Delegate

extension WalkDetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 3
        return renderer
    }
}
