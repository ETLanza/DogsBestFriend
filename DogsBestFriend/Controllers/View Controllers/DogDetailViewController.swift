//
//  DogDetailViewController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/12/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class DogDetailViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Properties

    var dog: Dog?
    var profileImageAsData: Data?
    let imagePickerController = UIImagePickerController()

    // MARK: - IBOutlets

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var changePictureLabel: UILabel!
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthdateDatePicker: UIDatePicker!
    @IBOutlet weak var adoptionDateDatePicker: UIDatePicker!
    @IBOutlet weak var microchipTextField: UITextField!
    @IBOutlet weak var breedTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var registrationTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }

    // MARK: - IBActions

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let name = nameTextField.text, !name.isEmpty else {
            //TODO: ALERT
            //displayMissingInfoAlert()
            return
        }
        let imageData = profileImageAsData ?? #imageLiteral(resourceName: "defaultProfileImage").pngData()
        if let dog = dog {
            DogController.shared.updateDog(dog, withName: name, birthdate: birthdateDatePicker.date, adoptionDate: adoptionDateDatePicker.date, microchipID: microchipTextField.text, breed: breedTextField.text, color: colorTextField.text, registration: registrationTextField.text, profileImageAsData: imageData!) { (success) in
                if success {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            DogController.shared.addDogWith(name: name, birthdate: birthdateDatePicker.date, adoptionDate: adoptionDateDatePicker.date, microchipID: microchipTextField.text, breed: breedTextField.text, color: colorTextField.text, registration: registrationTextField.text, profileImageAsData: imageData!) { (success) in
                if success {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    @IBAction func dogChangePictureTapped(_ sender: UITapGestureRecognizer) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_: UIAlertAction) in
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true, completion: nil)
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (_: UIAlertAction) in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)

        }))

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(actionSheet, animated: true)
    }

    // MARK: - Helper Methods

    func setUpViews() {
        imagePickerController.delegate = self
        tableView.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(tableViewSwiped)))
        scrollView.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(scrollViewSwiped)))
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        if let dog = dog {
            dogImageView.image = UIImage(data: dog.profileImageAsData)
            nameTextField.text = dog.name
            birthdateDatePicker.date = dog.birthdate
            adoptionDateDatePicker.date = dog.adoptionDate
            breedTextField.text = dog.breed
            microchipTextField.text = dog.microchipID
            colorTextField.text = dog.color
            registrationTextField.text = dog.registration
        }
    }

    @objc func tableViewSwiped() {
        scrollView.isScrollEnabled = false
        tableView.isScrollEnabled = true
    }

    @objc func scrollViewSwiped() {
        scrollView.isScrollEnabled = true
        tableView.isScrollEnabled = false
    }

    // MARK: - UIImagePickerController Delegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            let profileImageAsData = image.pngData()
            self.profileImageAsData = profileImageAsData
            dog?.profileImageAsData = profileImageAsData!
            dogImageView.image = image
            
            changePictureLabel.text = ""
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    // MARK: - TableView Data Scource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value) })
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
