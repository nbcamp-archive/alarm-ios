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
        self.window = window
        
        self.navigationController = UINavigationController()
        
        self.childCoordinators = [Coordinator]()
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
}
