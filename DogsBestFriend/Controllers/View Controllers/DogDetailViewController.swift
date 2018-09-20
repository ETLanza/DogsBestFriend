//
//  DogDetailViewController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/12/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class DogDetailViewController: UIViewController, UIScrollViewDelegate {
    // MARK: - Properties

    var dog: Dog?
    var tempDog = Dog(name: "temp", birthdate: Date(), adoptionDate: Date(), microchipID: "", breed: "", color: "", registration: "", profileImageAsData: Data(), medicalHistory: [])
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
    @IBOutlet weak var medicalView: UIView!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - IBActions

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let name = nameTextField.text, !name.isEmpty else {
            //TODO: ALERT
            //displayMissingInfoAlert()
            return
        }
        let imageData = profileImageAsData ?? #imageLiteral(resourceName: "coolDog").pngData()
        if let dog = dog {
            DogController.shared.updateDog(dog, withName: name, birthdate: birthdateDatePicker.date, adoptionDate: adoptionDateDatePicker.date, microchipID: microchipTextField.text, breed: breedTextField.text, color: colorTextField.text, registration: registrationTextField.text, profileImageAsData: imageData!, medicalHistory: dog.medicalHistory) { success in
                if success {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            DogController.shared.addDogWith(name: name, birthdate: birthdateDatePicker.date, adoptionDate: adoptionDateDatePicker.date, microchipID: microchipTextField.text, breed: breedTextField.text, color: colorTextField.text, registration: registrationTextField.text, profileImageAsData: imageData!, medicalHistory: tempDog.medicalHistory) { success in
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        if let dog = dog {
            title = dog.name
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

    @objc func keyboardWillShow(notification: NSNotification) {
        var userInfo = notification.userInfo!
        var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 50
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editMedicalSegue" {
            guard let destinationVC = segue.destination as? MedicalViewController,
                let index = tableView.indexPathForSelectedRow else { return }
            if dog == nil {
                destinationVC.medicalRecord = tempDog.medicalHistory[index.row]
                destinationVC.editingRecord = true
                destinationVC.index = index.row
            } else {
                destinationVC.medicalRecord = dog?.medicalHistory[index.row]
                destinationVC.editingRecord = true
                destinationVC.index = index.row
            }
        }
    }

    @IBAction func unwindFromMedicalVCWithData(_ sender: UIStoryboardSegue) {
        if sender.source is MedicalViewController {
            if let senderVC = sender.source as? MedicalViewController {
                if dog == nil {
                    if senderVC.editingRecord {
                        tempDog.medicalHistory.remove(at: senderVC.index!)
                        tempDog.medicalHistory.insert(senderVC.medicalRecord!, at: senderVC.index!)
                    } else {
                        tempDog.medicalHistory.append(senderVC.medicalRecord!)
                    }
                } else {
                    if senderVC.editingRecord {
                        dog!.medicalHistory.remove(at: senderVC.index!)
                        dog!.medicalHistory.insert(senderVC.medicalRecord!, at: senderVC.index!)
                    } else {
                        dog!.medicalHistory.insert(senderVC.medicalRecord!, at: 0)
                    }
                }
            }
            tableView.reloadData()
        }
    }

    @IBAction func unwindFromMedicalVC(_ sender: UIStoryboardSegue) {
        tableView.reloadData()
    }
}

// MARK: - TableView Data Scource

extension DogDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dog == nil {
            return tempDog.medicalHistory.count
        } else {
            return dog?.medicalHistory.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "medicalCell", for: indexPath)
        if dog == nil {
            cell.textLabel?.text = tempDog.medicalHistory[indexPath.row].name
            cell.detailTextLabel?.text = DisplayFormatter.date(tempDog.medicalHistory[indexPath.row].date)
        } else {
            cell.textLabel?.text = dog?.medicalHistory[indexPath.row].name
            cell.detailTextLabel?.text = DisplayFormatter.date(dog?.medicalHistory[indexPath.row].date)
        }
        return cell
    }
}

// MARK: - ImagePicker Delegate

extension DogDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - UIImagePickerController Delegate Methods

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage, let fixedImage = image.fixOrientation() {
            let profileImageAsData = fixedImage.pngData()
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
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value) })
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
