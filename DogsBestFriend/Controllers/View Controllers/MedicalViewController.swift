//
//  MedicalViewController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/18/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class MedicalViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var medicalNameTextField: UITextField!
    @IBOutlet weak var medicalDatePicker: UIDatePicker!
    @IBOutlet weak var noteTextView: UITextView!

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }

    // MARK: - IBActions

    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
       dismiss(animated: true, completion: nil)
    }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
    }

    // MARK: - Helper Methods

    func setUpViews() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}
