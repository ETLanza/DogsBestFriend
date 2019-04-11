//
//  FUIAuthPickerViewController+Extension.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 4/10/19.
//  Copyright © 2019 ETLanza. All rights reserved.
//

import Foundation
import FirebaseUI

extension FUIAuthPickerViewController {
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = ""
    }
}
