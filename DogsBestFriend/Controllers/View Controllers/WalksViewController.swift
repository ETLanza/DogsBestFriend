//
//  WalksViewController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/10/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit

class WalksViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var addWalkButton: UIButton!
    @IBOutlet weak var noPastWalksView: UIView!
    @IBOutlet weak var pastWalkTableView: UITableView!

    // MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadPastWalks()
    }

    // MARK: - Helper Methods

    func setUpViews() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        addWalkButton.layer.cornerRadius = addWalkButton.frame.height / 2
        addWalkButton.layer.masksToBounds = true
    }

    func reloadPastWalks() {
        pastWalkTableView.reloadData()
        if WalkController.shared.walks.isEmpty {
            noPastWalksView.isHidden = false
        } else {
            noPastWalksView.isHidden = true
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}

extension WalksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WalkController.shared.walks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "walkCell", for: indexPath)

        let walk = WalkController.shared.walks[indexPath.row]

        cell.textLabel?.text = DisplayFormatter.date(walk.timestamp)
        cell.detailTextLabel?.text = DisplayFormatter.time(walk.duration)

        return cell
    }

}
