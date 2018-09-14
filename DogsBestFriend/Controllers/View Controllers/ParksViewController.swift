//
//  ParksViewController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/10/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import MapKit
import UIKit

class ParksViewController: UIViewController {
    // MARK: - Properties

    var matchingItems: [MKMapItem] = []
    var selectedPin: MKPlacemark?

    // MARK: - IBOutlets

    @IBOutlet weak var favoritesSegmentedControl: UISegmentedControl!
    @IBOutlet weak var zipCodeSearchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var drawerView: UIView!
    @IBOutlet weak var parksTableView: UITableView!
    @IBOutlet weak var drawerClosedConstraint: NSLayoutConstraint!
    @IBOutlet weak var nearbyViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var favoritesViewTrailingConstraint: NSLayoutConstraint!

    // MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        addSearchButtonTo(searchBar: zipCodeSearchBar)
        setUpMapKit()
        searchForDogParks(searchLocation: LocationManager.shared.location!.coordinate)
    }

    // MARK: - IBActions

    @IBAction func drawerSwipedUp(_ sender: UISwipeGestureRecognizer) {
        drawerClosedConstraint.priority = UILayoutPriority(rawValue: 997)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func drawerSwipedDown(_ sender: UISwipeGestureRecognizer) {
        drawerClosedConstraint.priority = UILayoutPriority(rawValue: 999)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func favoritesSegementedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            favoritesViewTrailingConstraint.priority = UILayoutPriority(rawValue: 999)
            nearbyViewLeadingConstraint.priority = UILayoutPriority(rawValue: 997)
        } else if sender.selectedSegmentIndex == 1 {
            favoritesViewTrailingConstraint.priority = UILayoutPriority(rawValue: 997)
            nearbyViewLeadingConstraint.priority = UILayoutPriority(rawValue: 999)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - Map Kit Helper Methods

    func setUpMapKit() {
        LocationManager.shared.delegate = self
        enableBasicLocationServices()
    }

    func enableBasicLocationServices() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            LocationManager.shared.requestWhenInUseAuthorization()
            break

        case .restricted, .denied:
//            disableMyLocationBasedFeatures()
            break

        case .authorizedWhenInUse, .authorizedAlways:
            LocationManager.shared.requestLocation()
            break
        }
    }

    func searchForDogParks(searchLocation: CLLocationCoordinate2D) {
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = "dog park"
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(searchLocation, span)
        searchRequest.region = region

        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { response, error in
            if let error = error {
                NSLog("Error searching for dog parks: %@", error.localizedDescription)
                return
            }

            guard let response = response else {
                NSLog("No dog park search response")
                return
            }
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.matchingItems = response.mapItems
            response.mapItems.forEach { self.addPinFor(placemark: $0.placemark) }
            self.parksTableView.reloadData()
            self.mapView.setRegion(region, animated: true)
        }
    }

    // MARK: - Helper Methods

    func addPinFor(placemark: MKPlacemark) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
    }

    func dropPinZoomIn(placemark: MKPlacemark) {
        selectedPin = placemark
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
}

// MARK: - UITableView Data Source and Delegates
extension ParksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = parksTableView.dequeueReusableCell(withIdentifier: "parkCell", for: indexPath) as? ParkTableViewCell else { return UITableViewCell() }

        let item = matchingItems[indexPath.row].placemark
        cell.delegate = self
        cell.parkNameLabel.text = item.name
        cell.placemark = item

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        dropPinZoomIn(placemark: selectedItem)
        drawerClosedConstraint.priority = UILayoutPriority(rawValue: 999)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

// MARK: - Core Location Manager Delegate

extension ParksViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            LocationManager.shared.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error)")
    }
}

// MARK: - MapKit Delegate

extension ParksViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.red
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "dogCar"), for: .normal)
        button.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }

    @objc func getDirections() {
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
}

// MARK: - Search Bar Helper Methods
extension ParksViewController {
    func addSearchButtonTo(searchBar: UISearchBar) {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let search = UIBarButtonItem(title: "Search", style: .done, target: self, action: #selector(searchButtonAction))

        let items = [flexSpace, search]
        toolbar.items = items
        toolbar.sizeToFit()
        searchBar.inputAccessoryView = toolbar
    }

    @objc func searchButtonAction() {
        guard let searchText = zipCodeSearchBar.text, !searchText.isEmpty else {
            return
        }
        let clGeocoder = CLGeocoder()
        clGeocoder.geocodeAddressString(searchText) { placemarks, error in
            if let error = error {
                print(error.localizedDescription)
                //                    displayZipCodeSearchErrorAlert()
                return
            }
            guard let placemarks = placemarks else {
                print("Error with zipcode placemarks")
                //                    displayZipCodeSearchErrorAlert()
                return
            }
            self.searchForDogParks(searchLocation: placemarks.first!.location!.coordinate)
            self.zipCodeSearchBar.resignFirstResponder()
        }
    }
}

extension ParksViewController: ParkTableViewCellDelegate {
    func parkDetailsButtonTapped(_ sender: ParkTableViewCell) {
        let storyboard = UIStoryboard(name: "ParkDetail", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "parkDetailVC") as? ParkDetailViewController
        destinationVC?.placemark = sender.placemark
        destinationVC?.modalPresentationStyle = .overCurrentContext
        destinationVC?.modalTransitionStyle = .crossDissolve
        present(destinationVC!, animated: true, completion: nil)
    }

    func directionsButtonTapped(_ sender: ParkTableViewCell) {

    }

    func favoriteButtonTapped(_ sender: ParkTableViewCell) {
        sender.favoritesButton.setImage(#imageLiteral(resourceName: "favoritedHeart"), for: .normal)
    }
}
