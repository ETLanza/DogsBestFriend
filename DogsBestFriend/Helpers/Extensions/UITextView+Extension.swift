//
//  UITextView+Extension.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 4/12/19.
//  Copyright © 2019 ETLanza. All rights reserved.
//

import UIKit

extension UITextView {
    @IBInspectable var doneAccessory: Bool {
        get {
            return self.doneAccessory
        }
        set(hasDone) {
            if hasDone {
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    @IBInspectable var nextAccessory: Bool {
        get {
            return self.nextAccessory
        }
        set(hasDone) {
            if hasDone {
                addNextButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        done.tintColor = UIColor.init(named: "mainColor")
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        inputAccessoryView = doneToolbar
    }
    
    func addNextButtonOnKeyboard() {
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let next = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(doneButtonAction))
        next.tintColor = UIColor.init(named: "mainColor")
        
        let items = [flexSpace, next]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        resignFirstResponder()
    }
}
