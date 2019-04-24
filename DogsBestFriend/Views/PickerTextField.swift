//
//  PickerTextField.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 4/23/19.
//  Copyright © 2019 ETLanza. All rights reserved.
//

import UIKit

/*
 This subclass is used for any of the UITextFields that have a picker view for its keyboard types. These overrides just remove the blinking text selection cursor as no text will be typed in these fields
 */
class PickerTextField: UITextField {
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
    
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }
}
