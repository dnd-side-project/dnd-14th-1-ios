//
//  TabBarCoordinator.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/14/26.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let tabBarController: UITabBarController = UITabBarController()
    
    private let navigationController: UINavigationController
    private let tabBarView = TabBarView()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        setupTabBarStyle()
    }
    
    func start() {
        // 탭별 navigationController 생성
        let myEcoNavigationController = makeNavigationController(tab: .eco)
        let diagnosisNavigationController = makeNavigationController(tab: .diagnosis)
        let settingNavigationController = makeNavigationController(tab: .settings)
        
        // Coordinator 생성
        let myEcoCoordinator = MyEcoCoordinator(navigationController: myEcoNavigationController)
        let diagnosisCoordinator = DiagnosisCoordinator(navigationController: diagnosisNavigationController)
        let settingCoordinator = SettingCoordinator(navigationController: settingNavigationController)
        
        // ChildCoordinator 설정
        childCoordinators = [
            myEcoCoordinator,
            diagnosisCoordinator,
            settingCoordinator
        ]
        
        myEcoCoordinator.start()
        diagnosisCoordinator.start()
        settingCoordinator.start()
        
        tabBarController.setViewControllers(
            [
                diagnosisNavigationController,
                myEcoNavigationController,
                settingNavigationController
            ],
            animated: false
        )
        
        navigationController.setViewControllers([tabBarController], animated: false)
    }
    
    private func setupTabBarStyle() {
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().selectedImageTintColor = .primary550
        UITabBar.appearance().unselectedItemTintColor = .gray300
        
        tabBarController.setValue(tabBarView, forKey: "tabBar")
        tabBarController.tabBar.itemPositioning = .centered
        tabBarController.tabBar.itemSpacing = 48
        tabBarController.tabBar.itemWidth = 52
    }
    
    private func makeNavigationController(tab: TabBarItem) -> UINavigationController {
        let navigationController = UINavigationController()
        let item = UITabBarItem(
            title: tab.title,
            image: UIImage(named: tab.iconName),
            tag: tab.pageIndex)
        
        let attributes = [NSAttributedString.Key.font:UIFont.label2_b]
        item.setTitleTextAttributes(attributes, for: .normal)
        item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        navigationController.tabBarItem = item
        
        return navigationController
    }
}
