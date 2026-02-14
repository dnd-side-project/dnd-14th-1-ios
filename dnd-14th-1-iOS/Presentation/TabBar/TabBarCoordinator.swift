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
            [   myEcoNavigationController,
                diagnosisNavigationController,
                settingNavigationController
            ],
            animated: false
        )
        
        navigationController.setViewControllers([tabBarController], animated: false)
    }
    
    private func setupTabBarStyle() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        tabBarController.tabBar.standardAppearance = appearance
    }
    
    private func makeNavigationController(tab: TabBarItem) -> UINavigationController {
        let navigationController = UINavigationController()
        
        navigationController.tabBarItem = UITabBarItem(
            title: tab.title,
            image: UIImage(named: tab.iconName),
            tag: tab.pageIndex
        )
        
        return navigationController
    }
}
