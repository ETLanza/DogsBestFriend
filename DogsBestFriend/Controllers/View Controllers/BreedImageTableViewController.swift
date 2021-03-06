//
//  BreedImageTableViewController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 7/18/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class BreedImageTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: - Properties

    @IBOutlet weak var dogBreedTextField: UITextField!
    @IBOutlet weak var dogBreedImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var breedPicker: UIPickerView!
    @IBOutlet weak var getRandomImageButton: MainButton!

    // MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        
        BreedController.getBreeds { success in
            if success {
                DispatchQueue.main.async {
                    self.dogBreedTextField.inputView = self.breedPicker
                }
            }
        }
    }

    // MARK: - IBActions

    @IBAction func getRandomImageTapped(_ sender: UIButton) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        activityIndicator.startAnimating()
        getRandomImageButton.isEnabled = false
        dogBreedTextField.resignFirstResponder()
        let index = breedPicker.selectedRow(inComponent: 0)
        let breed = BreedController.breeds[index]
        BreedController.getRandomImageFor(breed: breed) { image in
            if image == nil {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.getRandomImageButton.isEnabled = true
                    self.activityIndicator.stopAnimating()
                }
            }
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.dogBreedImageView.image = image
                self.getRandomImageButton.isEnabled = true
                self.activityIndicator.stopAnimating()
            }
        }
    }

    // MARK: - Helper Methods

    func setUpViews() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        var userInfo = notification.userInfo!
        var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset: UIEdgeInsets = self.tableView.contentInset
        contentInset.bottom = keyboardFrame.size.height - 90
        tableView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset = UIEdgeInsets.zero
        tableView.contentInset = contentInset
    }

    // MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return tableView.frame.width
        }
        return 50
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return tableView.frame.width
        }
        return 50
    }

    // MARK: - Gesture Recognizer

    @IBAction func userTappedView(_ sender: UITapGestureRecognizer) {
        dogBreedTextField.resignFirstResponder()
    }

    // MARK: - UIPicker Data Source Methods

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return BreedController.breeds.count
    }

    // MARK: - UIPicker Delegate Methods

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return BreedController.breeds[row].name.capitalized
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dogBreedTextField.text = BreedController.breeds[row].name.capitalized
    }
}
