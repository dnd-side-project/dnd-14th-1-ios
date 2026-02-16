//
//  SettingCoordinator.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/14/26.
//

import UIKit

final class SettingCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let settingViewController = SettingViewController()
        navigationController.pushViewController(settingViewController, animated: true)
    }
}
