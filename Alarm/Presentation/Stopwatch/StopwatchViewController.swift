//
//  StopwatchViewController.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-09-26.
//

import UIKit

class StopwatchViewController: BaseUIViewController {
    
    weak var coordinator: StopwatchViewCoordinator?
    
    override func setTitle() {
        title = "스톱워치"
    }
    
}
