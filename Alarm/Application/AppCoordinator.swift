//
//  AppCoordinator.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-09-26.
//

import UIKit

class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator]
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.navigationController = UINavigationController()
        
        self.childCoordinators = [Coordinator]()
        
        self.window = window
    }
    
    func start() {
        let coordinator = MainTabBarCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()

        navigationController.setNavigationBarHidden(true, animated: true)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
}
