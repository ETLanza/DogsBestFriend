//
//  DogDetailViewController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/12/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class DogDetailViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
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
        tableView.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(tableViewSwiped)))
        scrollView.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(scrollViewSwiped)))
    }

    @IBAction func medicalAddButtonTapped(_ sender: UIButton) {
    }

    // MARK: - Helper Methods

    @objc func tableViewSwiped() {
        scrollView.isScrollEnabled = false
        tableView.isScrollEnabled = true
    }

    @objc func scrollViewSwiped() {
        scrollView.isScrollEnabled = true
        tableView.isScrollEnabled = false
    }

    // MARK: - TableView Data Scource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
