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
    var medicalHistory: [MedicalRecord] = []
    var profileImageAsData: Data?
    let imagePickerController = UIImagePickerController()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var changePictureLabel: UILabel!
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthdateDatePicker: UIDatePicker!
    @IBOutlet weak var birthdateTextField: UITextField!
    @IBOutlet weak var adoptionDateDatePicker: UIDatePicker!
    @IBOutlet weak var adoptionDateTextField: UITextField!
    @IBOutlet weak var microchipTextField: UITextField!
    @IBOutlet weak var breedTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var registrationTextField: UITextField!
    @IBOutlet weak var medicalView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var removeDogButton: UIButton!
    
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
            let missingInfoAlert = AlertManager.displayAlertMessage(userMessage: "The name field must be filled out")
            present(missingInfoAlert, animated: true, completion: nil)
            return
        }
        let imageData = profileImageAsData ?? #imageLiteral(resourceName: "coolDog").jpegData(compressionQuality: 0.7)
        if let dog = dog {
            DogController.shared.updateDog(dog, withName: name, birthdate: birthdateDatePicker.date, adoptionDate: adoptionDateDatePicker.date, microchipID: microchipTextField.text, breed: breedTextField.text, color: colorTextField.text, registration: registrationTextField.text, profileImageAsData: imageData!, medicalHistory: dog.medicalHistory) { success in
                if success {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            DogController.shared.addDogWith(name: name, birthdate: birthdateDatePicker.date, adoptionDate: adoptionDateDatePicker.date, microchipID: microchipTextField.text, breed: breedTextField.text, color: colorTextField.text, registration: registrationTextField.text, profileImageAsData: imageData!, medicalHistory: medicalHistory) { success in
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
    
    @IBAction func removeDogButtonTapped(_ sender: UIButton) {
        let removeDogAlertController = UIAlertController(title: "Remove \(dog!.name)?", message: "Are you sure you want to delete all data for \(dog!.name)", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            DogController.shared.deleteDog(self.dog!, completion: { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        removeDogAlertController.addAction(deleteAction)
        removeDogAlertController.addAction(cancelAction)
        
        present(removeDogAlertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Helper Methods
    
    func setUpViews() {
        imagePickerController.delegate = self
        removeDogButton.layer.cornerRadius = 12
        removeDogButton.layer.masksToBounds = true
        setUpTextFields()
        tableView.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(tableViewSwiped)))
        scrollView.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(scrollViewSwiped)))
        birthdateDatePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        adoptionDateDatePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        if let dog = dog {
            title = dog.name
            dogImageView.image = UIImage(data: dog.profileImageAsData!)
            nameTextField.text = dog.name
            birthdateDatePicker.date = dog.birthdate
            birthdateTextField.text = dog.birthdateAsString
            adoptionDateDatePicker.date = dog.adoptionDate
            adoptionDateTextField.text = dog.adoptionDateAsString
            breedTextField.text = dog.breed
            microchipTextField.text = dog.microchipID
            colorTextField.text = dog.color
            registrationTextField.text = dog.registration
            removeDogButton.isHidden = false
        }
    }
    
    func setUpTextFields() {
        birthdateTextField.inputView = birthdateDatePicker
        adoptionDateTextField.inputView = adoptionDateDatePicker
        addInputAccessoryForTextFields(textFields: [nameTextField, birthdateTextField, adoptionDateTextField, microchipTextField, breedTextField, colorTextField, registrationTextField], dismissable: true, previousNextable: true)
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
    
    @objc func datePickerValueChanged(_ picker: UIDatePicker) {
        switch picker {
        case adoptionDateDatePicker:
            adoptionDateTextField.text = DisplayFormatter.stringFrom(date: adoptionDateDatePicker.date)
        case birthdateDatePicker:
            birthdateTextField.text = DisplayFormatter.stringFrom(date: birthdateDatePicker.date)
        default:
            break
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editMedicalSegue" {
            guard let destinationVC = segue.destination as? MedicalViewController,
                let index = tableView.indexPathForSelectedRow else { return }
            if dog == nil {
                destinationVC.medicalRecord = medicalHistory[index.row]
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
                        medicalHistory.remove(at: senderVC.index!)
                        medicalHistory.insert(senderVC.medicalRecord!, at: senderVC.index!)
                    } else {
                        medicalHistory.append(senderVC.medicalRecord!)
                    }
                } else {
                    if senderVC.editingRecord {
                        dog!.medicalHistory.remove(at: senderVC.index!)
                        dog!.medicalHistory.insert(senderVC.medicalRecord!, at: senderVC.index!)
                    } else {
                        dog!.medicalHistory.insert(senderVC.medicalRecord!, at: 0)
                    }
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                    DogController.shared.updateDog(dog!, withName: dog!.name,
                                                   birthdate: dog!.birthdate,
                                                   adoptionDate: dog!.adoptionDate,
                                                   microchipID: dog!.microchipID,
                                                   breed: dog!.breed,
                                                   color: dog!.color,
                                                   registration: dog!.registration,
                                                   profileImageAsData: dog!.profileImageAsData!,
                                                   medicalHistory: dog!.medicalHistory) { (success) in
                        if success {
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        } else {
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        }
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
            return medicalHistory.count
        } else {
            return dog?.medicalHistory.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "medicalCell", for: indexPath)
        if dog == nil {
            cell.textLabel?.text = medicalHistory[indexPath.row].name
            cell.detailTextLabel?.text = DisplayFormatter.stringFrom(date: medicalHistory[indexPath.row].date)
        } else {
            cell.textLabel?.text = dog?.medicalHistory[indexPath.row].name
            cell.detailTextLabel?.text = DisplayFormatter.stringFrom(date: dog?.medicalHistory[indexPath.row].date)
        }
        return cell
    }
}

// MARK: - UIImagePickerController Delegate Methods

extension DogDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage, let fixedImage = image.fixOrientation() {
            let profileImageAsData = fixedImage.jpegData(compressionQuality: 0.7)
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

// MARK: - UITextFieldDelegate Methods
extension DogDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            birthdateTextField.becomeFirstResponder()
        case birthdateTextField:
            adoptionDateTextField.becomeFirstResponder()
        case adoptionDateTextField:
            microchipTextField.becomeFirstResponder()
        case microchipTextField:
            breedTextField.becomeFirstResponder()
        case breedTextField:
            colorTextField.becomeFirstResponder()
        case colorTextField:
            registrationTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}

