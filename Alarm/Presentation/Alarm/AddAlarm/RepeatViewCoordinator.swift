//
//  RepeatViewCoordinator.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-09-27.
//

import UIKit

class RepeatViewCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        self.childCoordinators = [Coordinator]()
    }
    
    func start() {
        let viewController = RepeatViewController()
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
}
