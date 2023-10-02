//
//  AddAlarmViewCoordinator.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-09-27.
//

import UIKit

class AddAlarmViewCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    var stackNavigationController: UINavigationController
    
    var childCoordinators: [Coordinator]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        self.stackNavigationController = UINavigationController()
        
        self.childCoordinators = [Coordinator]()
    }
    
    func start() {
        let viewController = AddAlarmViewController()
        viewController.coordinator = self
        
        stackNavigationController = UINavigationController(rootViewController: viewController)
        navigationController.present(stackNavigationController, animated: true)
    }
    
    func toRepeatView() {
        let viewController = RepeatViewController()
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
}
