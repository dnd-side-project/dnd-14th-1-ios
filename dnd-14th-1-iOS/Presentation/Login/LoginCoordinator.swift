//
//  LoginCoordinator.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/14/26.
//

import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    func loginButtonTapped()
}

protocol LoginCoordinatorDelegate: AnyObject {
    func didCompleteLogin(_ coordinator: any Coordinator)
}

final class LoginCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var delegate: LoginCoordinatorDelegate?
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginViewController = LoginViewController()
        loginViewController.delegate = self
        navigationController.pushViewController(loginViewController, animated: true)
    }
}

extension LoginCoordinator: LoginViewControllerDelegate {
    func loginButtonTapped() {
        let onboardingViewController = OnboardingViewController()
        onboardingViewController.delegate = self
        navigationController.pushViewController(onboardingViewController, animated: true)
    }
}

extension LoginCoordinator: OnboardingViewControllerDelegate {
    func startButtonTapped() {
        delegate?.didCompleteLogin(self)
    }
}
