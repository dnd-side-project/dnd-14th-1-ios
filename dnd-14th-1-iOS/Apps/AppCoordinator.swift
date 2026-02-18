//
//  AppCoordinator.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/14/26.
//

import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    private var isLoggedIn: Bool
    
    init(navigationController: UINavigationController, isLoggedIn: Bool) {
        self.navigationController = navigationController
        self.isLoggedIn = isLoggedIn
        NotificationCenter.default.addObserver(self, selector: #selector(start), name: NSNotification.Name("DidLogout"), object: nil)
    }
    
    @objc func start() {
        if isLoggedIn {
            showTabBarCoordinator()
        } else {
            showLoginCoordinator()
        }
    }
    
    private func showTabBarCoordinator() {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
    }
    
    private func showLoginCoordinator() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        loginCoordinator.delegate = self
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
    }
}

extension AppCoordinator: LoginCoordinatorDelegate {
    func didCompleteLogin(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        showTabBarCoordinator()
    }
}
