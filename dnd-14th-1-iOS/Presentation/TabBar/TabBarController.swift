//
//  TabBarController.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/6/26.
//

import UIKit

final class TabBarController: UITabBarController {
    init() {
        super.init(nibName: nil, bundle: nil)
//        configureTabBarItems()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTabBarItems() {
        let viewControllers = TabBarItem.allCases.map {
            createTabNavigationController(tab: $0)
        }
        
        setViewControllers(viewControllers, animated: false)        
    }
    
    private func createTabNavigationController(tab: TabBarItem) -> UINavigationController {
        let rootVC = rootViewController(for: tab)
        rootVC.title = tab.title
        
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.tabBarItem = UITabBarItem(
            title: tab.title,
            image: UIImage(named: tab.iconName),
            tag: tab.pageIndex
        )
        
        return navigationController
    }
    
    private func rootViewController(for tab: TabBarItem) -> UIViewController {
        switch tab {
        case .eco:
            return EcoViewController()
        case .diagnosis:
            return DiagnosisViewController()
        case .settings:
            return SettingViewController()
        }
    }
}


