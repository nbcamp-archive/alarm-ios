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
}
