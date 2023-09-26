//
//  AlarmViewCoordinator.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-09-26.
//

import UIKit

class AlarmViewCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        self.childCoordinators = [Coordinator]()
    }
    
    func start() {
        let viewController = AlarmViewController()
        viewController.coordinator = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
}
