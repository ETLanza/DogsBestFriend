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
        addInputAccessoryForTextFields(textFields: [nameTextField], dismissable: true, previousNextable: false)
        noteTextView.layer.borderColor = UIColor.lightGray.cgColor
        noteTextView.layer.borderWidth = 0.25
        noteTextView.layer.cornerRadius = 5
        noteTextView.layer.masksToBounds = true
        if medicalRecord?.note != nil && medicalRecord?.note != "Enter notes..." {
            noteTextView.textColor = UIColor.black
        }
    }

    func setUpLabels() {
        nameTextField.text = medicalRecord?.name ?? "Was Nil"
        datePicker.date = medicalRecord?.date ?? Date()
        noteTextView.text = medicalRecord?.note ?? "Why Tho"
    }
}

extension MedicalViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if noteTextView.text == "Enter notes..." {
            noteTextView.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension MedicalViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textColor = UIColor.black
        if textView.text == "Enter notes..." {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Enter notes..."
            textView.textColor = UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0)
        }
    }
}
