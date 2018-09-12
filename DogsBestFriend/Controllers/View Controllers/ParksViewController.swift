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

    @IBOutlet var zipCodeTextField: UITextField!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var drawerView: UIView!
    @IBOutlet var parksTableView: UITableView!
    @IBOutlet var drawerClosedConstraint: NSLayoutConstraint!

    // MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        zipCodeTextField.addDoneButtonOnKeyboard()
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
