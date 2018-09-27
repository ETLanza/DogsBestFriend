//
//  MedicalViewController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/18/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class MedicalViewController: UIViewController {
    // MARK: - Properties

    var medicalRecord: MedicalRecord? {
        didSet {
            loadViewIfNeeded()
            setUpLabels()
        }
    }
    var editingRecord: Bool = false
    var index: Int?

    // MARK: - IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteTextView: UITextView!

    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }

    // MARK: - IBActions

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let name = nameTextField.text, !name.isEmpty else {
            let missingInfoAlert = AlertManager.displayAlertMessage(userMessage: "The name field must be filled out.")
            present(missingInfoAlert, animated: true, completion: nil)
            return
        }
        
        let note = noteTextView.text ?? ""
        let newMedical = MedicalRecord(name: name, date: datePicker.date, note: note)
        medicalRecord = newMedical
        performSegue(withIdentifier: "unwindFromMedicalVCWithData", sender: self)
    }

    // MARK: - Helper Methods

    func setUpViews() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    func setUpLabels() {
        nameTextField.text = medicalRecord?.name ?? "Was Nil"
        datePicker.date = medicalRecord?.date ?? Date()
        noteTextView.text = medicalRecord?.note ?? "Why Tho"
    }
}
