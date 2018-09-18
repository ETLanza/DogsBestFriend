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

    @IBOutlet var dogBreedTextField: UITextField!
    @IBOutlet var dogBreedImageView: UIImageView!
    @IBOutlet var breedPicker: UIPickerView!
    @IBOutlet var getRandomImageButton: UIButton!

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
        dogBreedTextField.resignFirstResponder()
        let index = breedPicker.selectedRow(inComponent: 0)
        let breed = BreedController.breeds[index]
        BreedController.getRandomImageFor(breed: breed) { image in
            if image == nil {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.dogBreedImageView.image = image
            }
        }
    }

    // MARK: - Helper Methods

    func setUpViews() {
        getRandomImageButton.layer.cornerRadius = 12
        getRandomImageButton.clipsToBounds = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
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
