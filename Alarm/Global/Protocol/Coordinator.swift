//
//  Coordinator.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-09-26.
//

import UIKit

protocol Coordinator: AnyObject {
    
    var navigationController: UINavigationController { get set }
    
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    
}
