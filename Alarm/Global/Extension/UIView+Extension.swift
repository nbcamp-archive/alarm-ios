//
//  UIView+Extension.swift
//  Alarm
//
//  Created by 이재희 on 2023/09/25.
//

import UIKit

extension UIView {
    var circleView: Bool {
        set {
            if newValue {
                self.layer.cornerRadius = 0.5 * self.bounds.size.width
                self.clipsToBounds = true
            } else {
                self.layer.cornerRadius = 0
                self.clipsToBounds = false
            }
        } get {
            return false
        }
    }
    
    @IBInspectable var semiTransparentWhiteBackground: Bool {
        get {
            return false
        }
        set {
            if newValue {
                let whiteColor = UIColor.white
                self.layer.backgroundColor = whiteColor.withAlphaComponent(0.3).cgColor
                self.layer.borderColor = whiteColor.withAlphaComponent(0.3).cgColor
                self.layer.borderWidth = 2
            } else {
                self.layer.backgroundColor = nil
                self.layer.borderColor = nil
                self.layer.borderWidth = 0
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
}
