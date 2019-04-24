//
//  YourDogViewController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/10/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class YourDogViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noDogView: UIView!
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadViews()
    }
    
    // MARK: - Helper Methods
    
    func setUpViews() {
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.tabBarController!.tabBar.layer.borderWidth = 0.50
        self.tabBarController!.tabBar.layer.borderColor = UIColor.clear.cgColor
        self.tabBarController?.tabBar.clipsToBounds = true
        
    }
    
    func reloadViews() {
        collectionView.reloadData()
        if DBFUserController.shared.loggedInUser!.dogs.isEmpty {
            noDogView.isHidden = false
        } else {
            noDogView.isHidden = true
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editDogSegue" {
            guard let destinationVC = segue.destination as? DogDetailViewController,
                let index = collectionView.indexPathsForSelectedItems?.first else { return }
            let dog = DBFUserController.shared.loggedInUser?.dogs[index.row]
            destinationVC.dog = dog
        }
    }
}

// MARK: - UICollectiongView Delegate and DataSource

extension YourDogViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DBFUserController.shared.loggedInUser?.dogs.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dogCell", for: indexPath) as? DogCollectionViewCell else { return UICollectionViewCell() }
        
        let dog = DBFUserController.shared.loggedInUser!.dogs[indexPath.row]
        let image = dog.profileImage
        cell.dog = dog
        cell.dogProfilePicture.image = image
        cell.dogNameLabel.text = dog.name
        
        return cell
    }
}
