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
    
    var selectedPin: MKPlacemark?
    var mapKitEnabled: Bool = false
    var didInitialSearch: Bool = false
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var favoritesSegmentedControl: UISegmentedControl!
    @IBOutlet weak var zipCodeSearchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var drawerView: UIView!
    @IBOutlet weak var parksTableView: UITableView!
    @IBOutlet weak var drawerClosedConstraint: NSLayoutConstraint!
    @IBOutlet weak var nearbyViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var favoritesViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var noFavoritesView: UIView!
    @IBOutlet weak var favoritesTableView: UITableView!
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpMapKit()
        if !DBFUserController.shared.loggedInUser!.favoriteParks.isEmpty {
            noFavoritesView.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let coordinates = LocationManager.shared.location?.coordinate, !didInitialSearch {
            searchForDogParks(searchLocation: coordinates)
            didInitialSearch = true
        }
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
            reloadFavoriteView()
        } else if sender.selectedSegmentIndex == 1 {
            favoritesViewTrailingConstraint.priority = UILayoutPriority(rawValue: 997)
            nearbyViewLeadingConstraint.priority = UILayoutPriority(rawValue: 999)
            parksTableView.reloadData()
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Helper Methods
    
    func reloadFavoriteView() {
        if !DBFUserController.shared.loggedInUser!.favoriteParks.isEmpty {
            noFavoritesView.isHidden = true
        } else {
            noFavoritesView.isHidden = false
        }
        favoritesTableView.reloadData()
    }
    
    func setUpViews() {
        addSearchesAndCancelButtonsTo(searchBar: zipCodeSearchBar)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        favoritesSegmentedControl.removeBorders()
        mapView.layer.cornerRadius = 12
        mapView.layer.masksToBounds = true
        drawerView.layer.cornerRadius = 12
        drawerView.layer.masksToBounds = true
    }
    
    // MARK: - Map Kit Helper Methods
    
    func setUpMapKit() {
        LocationManager.shared.delegate = self
        enableBasicLocationServices()
    }
    
    func enableBasicLocationServices() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            break
            
        case .restricted, .denied:
            mapKitEnabled = false
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
            mapKitEnabled = true
            LocationManager.shared.requestLocation()
            break
            
        @unknown default:
            fatalError()
        }
    }
    
    func searchForDogParks(searchLocation: CLLocationCoordinate2D) {
        if mapKitEnabled {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            ParkController.shared.changeFilterLocationTo(CLLocation(latitude: searchLocation.latitude, longitude: searchLocation.longitude))
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = "dog park"
            let span = MKCoordinateSpan(latitudeDelta: 0.9, longitudeDelta: 0.9)
            let region = MKCoordinateRegion(center: searchLocation, span: span)
            searchRequest.region = region
            
            let activeSearch = MKLocalSearch(request: searchRequest)
            ParkController.shared.removeAllNonFavoriteParks()
            activeSearch.start { response, error in
                if let error = error {
                    NSLog("Error searching for dog parks: %@", error.localizedDescription)
                    return
                }
                
                guard let response = response else {
                    NSLog("No dog park search response")
                    return
                }
                
            
                response.mapItems.forEach {
                    ParkController.shared.addParkWith(placemark: $0.placemark)
                }
                self.mapView.removeAnnotations(self.mapView.annotations)
                response.mapItems.forEach {
                    self.addPinFor(placemark: $0.placemark)
                }
                self.parksTableView.reloadData()
                self.mapView.setRegion(region, animated: true)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
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
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
}

// MARK: - UITableView Data Source and Delegates

extension ParksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == parksTableView {
            return ParkController.shared.parks.count
        } else {
            return DBFUserController.shared.loggedInUser?.favoriteParks.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "parkCell", for: indexPath) as? ParkTableViewCell else { return UITableViewCell() }
        var park: Park?
        
        if tableView == favoritesTableView {
            park = DBFUserController.shared.loggedInUser?.favoriteParks[indexPath.row]
        } else {
            park = ParkController.shared.parks[indexPath.row]
        }
        
        if DBFUserController.shared.loggedInUser!.favoriteParks.contains(park!) {
            cell.favoritesButton.setImage(#imageLiteral(resourceName: "favoritedHeart"), for: .normal)
            park?.isFavorite = true
        } else {
            cell.favoritesButton.setImage(#imageLiteral(resourceName: "emptyHeart"), for: .normal)
        }
        
        cell.delegate = self
        cell.park = park
        cell.parkAddressLabel.text = park!.address
        cell.parkNameLabel.text = park!.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedItem: MKPlacemark?
        if tableView == favoritesTableView {
            selectedItem = DBFUserController.shared.loggedInUser?.favoriteParks[indexPath.row].placemark
        } else {
            selectedItem = ParkController.shared.parks[indexPath.row].placemark
        }
        dropPinZoomIn(placemark: selectedItem!)
        drawerClosedConstraint.priority = UILayoutPriority(rawValue: 999)
        favoritesViewTrailingConstraint.priority = UILayoutPriority(rawValue: 997)
        nearbyViewLeadingConstraint.priority = UILayoutPriority(rawValue: 999)
        favoritesSegmentedControl.selectedSegmentIndex = 1
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        favoritesSegmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
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
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let selectedLoc = view.annotation
        
        let currentLocMapItem = MKMapItem.forCurrentLocation()
        
        let selectedPlacemark = MKPlacemark(coordinate: selectedLoc!.coordinate, addressDictionary: nil)
        let selectedMapItem = MKMapItem(placemark: selectedPlacemark)
        
        let mapItems = [selectedMapItem, currentLocMapItem]
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        
        MKMapItem.openMaps(with: mapItems, launchOptions: launchOptions)
    }
}

// MARK: - Search Bar Helper Methods

extension ParksViewController {
    func addSearchesAndCancelButtonsTo(searchBar: UISearchBar) {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = .default
        
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let resetSearch = UIBarButtonItem(title: "Reset", style: .done, target: self, action: #selector(resetButtonAction))
        let search = UIBarButtonItem(title: "Search", style: .done, target: self, action: #selector(searchButtonAction))
        
        let items = [cancel, resetSearch, flexSpace, search]
        toolbar.items = items
        toolbar.sizeToFit()
        searchBar.inputAccessoryView = toolbar
    }
    
    @objc func searchButtonAction() {
        ParkController.shared.removeAllNonFavoriteParks()
        guard let searchText = zipCodeSearchBar.text, !searchText.isEmpty else {
            return
        }
        let clGeocoder = CLGeocoder()
        clGeocoder.geocodeAddressString(searchText) { placemarks, error in
            if let error = error {
                print(error.localizedDescription)
                let wrongZipCodeAlert = AlertManager.displayAlertMessage(userMessage: "The zip code could not be searched!")
                self.present(wrongZipCodeAlert, animated: true, completion: nil)
                return
            }
            guard let placemarks = placemarks else {
                print("Error with zipcode placemarks")
                let noPlacemarksAlert = AlertManager.displayAlertMessage(userMessage: "No parks found near that zipcode")
                self.present(noPlacemarksAlert, animated: true, completion: nil)
                return
            }
            self.searchForDogParks(searchLocation: placemarks.first!.location!.coordinate)
            self.zipCodeSearchBar.resignFirstResponder()
        }
    }
    
    @objc func resetButtonAction() {
        if let coordinates = LocationManager.shared.location?.coordinate {
            searchForDogParks(searchLocation: coordinates)
            zipCodeSearchBar.text = ""
            zipCodeSearchBar.resignFirstResponder()
        }
    }
    
    @objc func cancelButtonAction() {
        zipCodeSearchBar.resignFirstResponder()
    }
}

// MARK: - ParkTableViewCellDelegate

extension ParksViewController: ParkTableViewCellDelegate {
    func directionsButtonTapped(_ sender: ParkTableViewCell) {
        let alertController = UIAlertController(title: "Open in Apple Maps?", message: "This will close Dog's Best Friend to show directions to the park", preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Continue", style: .default) { _ in
            let currentLocMapItem = MKMapItem.forCurrentLocation()
            let selectedMapItem = MKMapItem(placemark: sender.park!.placemark)
            selectedMapItem.name = sender.park?.name ?? "Unknown Dog Park"
            let mapItems = [selectedMapItem, currentLocMapItem]
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            MKMapItem.openMaps(with: mapItems, launchOptions: launchOptions)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(continueAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func favoriteButtonTapped(_ sender: ParkTableViewCell) {
        let park = sender.park
        if park!.isFavorite {
            let favoriteAlertController = UIAlertController(title: "Unfavorite \(park!.name)?", message: nil, preferredStyle: .alert)
            
            let unfavoriteAction = UIAlertAction(title: "Unfavorite", style: .destructive) { (_) in
                DispatchQueue.main.async {
                    sender.favoritesButton.setImage(#imageLiteral(resourceName: "emptyHeart"), for: .normal)
                    ParkController.shared.removeFavorite(park: park!, completion: { (success) in
                        if success {
                            DispatchQueue.main.async {
                                self.reloadFavoriteView()
                                park?.isFavorite = !park!.isFavorite
                            }
                        }
                    })
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            favoriteAlertController.addAction(unfavoriteAction)
            favoriteAlertController.addAction(cancelAction)
            present(favoriteAlertController, animated: true, completion: nil)
        } else {
            sender.favoritesButton.setImage(#imageLiteral(resourceName: "favoritedHeart"), for: .normal)
            park?.isFavorite = !park!.isFavorite
            ParkController.shared.addFavorite(park: park!) { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.reloadFavoriteView()
                    }
                }
            }
        }
    }
}
