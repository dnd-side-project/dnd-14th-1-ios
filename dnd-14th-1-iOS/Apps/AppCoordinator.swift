//
//  AppCoordinator.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/14/26.
//

import UIKit
import Combine

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    private let checkLoginUseCase: CheckLoginUseCase
    private var subscriptions: Set<AnyCancellable> = []
    
    init(navigationController: UINavigationController,
         checkLoginUseCase: CheckLoginUseCase) {
        self.navigationController = navigationController
        self.checkLoginUseCase = checkLoginUseCase
        NotificationCenter.default.addObserver(self, selector: #selector(start), name: NSNotification.Name("DidLogout"), object: nil)
    }
    
    @objc func start() {
        childCoordinators = []
        
        checkLoginUseCase.execute().receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] isLoggedIn in
            guard let self else { return }
            if isLoggedIn {
                showTabBarCoordinator()
            } else {
                showLoginCoordinator()
            }
        }).store(in: &subscriptions)
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
    func didCompleteOnBoarding(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        showTabBarCoordinator()
    }
}
