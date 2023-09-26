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
    
    var tabBarItemCases: [MainTabBarItemType]
    var tabBarController: UITabBarController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        self.childCoordinators = [Coordinator]()
        
        self.tabBarItemCases = MainTabBarItemType.allCases
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        let tabBarItems = tabBarItemCases.map({ createTabBarItem(from: $0) })
        
        let viewControllers = tabBarItems.map({ createNavigationController(from: $0) })
        
        let _ = viewControllers.map({ createChildCoordinator(from: $0) })
        
        prepareTabBarController(viewControllers: viewControllers)
        
        attachTabBarController()
    }
    
}

extension MainTabBarCoordinator {
    
    private func attachTabBarController() {
        self.navigationController.pushViewController(tabBarController, animated: true)
    }
    
    private func prepareTabBarController(viewControllers: [UIViewController]) {
        tabBarController.setViewControllers(viewControllers, animated: false)
        tabBarController.selectedIndex = MainTabBarItemType.weather.toInt()
        
        tabBarController.view.backgroundColor = .systemBackground
        
        tabBarController.tabBar.isTranslucent = true
        tabBarController.tabBar.tintColor = UIColor.black
        tabBarController.tabBar.unselectedItemTintColor = UIColor.systemGray
    }
    
    private func createChildCoordinator(from navigationController: UINavigationController) {
        let tag = navigationController.tabBarItem.tag
        guard let tabBarItemType = MainTabBarItemType(index: tag) else { return }
        
        switch tabBarItemType {
        case .weather:
            let coordinator = WeatherViewCoordinator(navigationController: navigationController)
            childCoordinators.append(coordinator)
            coordinator.start()
        case .alarm:
            let coordinator = AlarmViewCoordinator(navigationController: navigationController)
            childCoordinators.append(coordinator)
            coordinator.start()
        case .stopwatch:
            navigationController.navigationBar.isHidden = true
            let coordinator = StopwatchViewCoordinator(navigationController: navigationController)
            childCoordinators.append(coordinator)
            coordinator.start()
        case .timer:
            navigationController.navigationBar.isHidden = true
            let coordinator = TimerViewCoordinator(navigationController: navigationController)
            childCoordinators.append(coordinator)
            coordinator.start()
        }
    }
    
    private func createNavigationController(from tabBarItem: UITabBarItem) -> UINavigationController {
        let navigationController = UINavigationController()
        
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.isTranslucent = true
        navigationController.tabBarItem = tabBarItem
        
        return navigationController
    }
    
    private func createTabBarItem(from tabBarItem: MainTabBarItemType) -> UITabBarItem {
        let title = tabBarItem.toSymbolName()
        let symbolName = tabBarItem.toSymbol()
        let tag = tabBarItem.toInt()
        
        return UITabBarItem(title: title, image: UIImage(systemName: symbolName), tag: tag)
    }
    
}
