//
//  AddAlarmViewCoordinator.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-09-27.
//

import UIKit

class AddAlarmViewCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        self.childCoordinators = [Coordinator]()
    }
    
    func start() {
        let viewController = AddAlarmViewController()
        viewController.coordinator = self
        
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.present(viewController, animated: true)
    }
    
}
