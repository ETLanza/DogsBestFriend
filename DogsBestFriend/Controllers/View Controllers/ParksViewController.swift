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
        zipCodeSearchBar.addDoneButtonOnKeyboard()
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

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
}

// MARK: - UITextFieldDelegate Methods

extension ParksViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
