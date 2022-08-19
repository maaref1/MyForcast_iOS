//
//  UIView+extension.swift
//  MyForcastApp
//
//  Created by MacBook Air on 19/08/2022.
//

import Foundation
import UIKit

extension UIView {
    /*
     New Inspectable for Setting CornerRadius
     */
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
    }
    
    /*
     This Fuction to set a click handler sending the target to manage the click and its action
     */
    func setOnClickListener(target: Any?, action: Selector) {
        let gesture = UITapGestureRecognizer(target: target, action: action)
        gesture.numberOfTapsRequired = 1
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
    }
    
}
