//
//  TimerViewController.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-09-26.
//

import UIKit

class TimerViewController: BaseUIViewController {
    
    weak var coordinator: TimerViewCoordinator?
    
    override func setTitle() {
        title = "타이머"
    }
    
}
