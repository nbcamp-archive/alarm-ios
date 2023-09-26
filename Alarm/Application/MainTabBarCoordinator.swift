//
//  MainTabBarCoordinator.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-09-26.
//

import UIKit

class MainTabBarCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator]
    
    var tabBarItems: [MainTabBarItemType]
    var tabBarController: UITabBarController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        self.childCoordinators = [Coordinator]()
        
        self.tabBarItems = [.weather, .alarm, .stopwatch, .timer]
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        let viewControllers = tabBarItems.map({ getTabController(tabBarItem: $0) })
        
        prepareTabBarController(with: viewControllers)
    }
    
}

extension MainTabBarCoordinator {
    
    private func getTabController(tabBarItem: MainTabBarItemType) -> UINavigationController {
        let navigationController = UINavigationController()
        
        let tabItem = UITabBarItem(title: tabBarItem.toSymbolName(), image: UIImage(systemName: tabBarItem.toSymbol()), selectedImage: nil)
        navigationController.tabBarItem = tabItem
        
        let coordinator = tabBarItem.getCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
        
        return navigationController
    }
    
    private func prepareTabBarController(with viewControllers: [UIViewController]) {
        tabBarController.setViewControllers(viewControllers, animated: true)
        tabBarController.selectedIndex = 0
        tabBarController.tabBar.isTranslucent = true
        
        navigationController.viewControllers = [tabBarController]
    }
    
}
