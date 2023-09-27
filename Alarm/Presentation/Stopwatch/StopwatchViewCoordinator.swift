//
//  StopWatchViewCoordinator.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-09-26.
//

import UIKit

class StopWatchViewCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        self.childCoordinators = [Coordinator]()
    }
    
    func start() {
        let storyboard = UIStoryboard(name: "StopWatchPage", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "StopWatchViewControllerID") as! StopWatchViewController
        
        viewController.coordinator = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
}
