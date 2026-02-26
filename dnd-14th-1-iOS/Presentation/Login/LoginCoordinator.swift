//
//  LoginCoordinator.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/14/26.
//

import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    func didCompleteLogin()
}

protocol LoginCoordinatorDelegate: AnyObject {
    func didCompleteOnBoarding(_ coordinator: any Coordinator)
}

final class LoginCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var delegate: LoginCoordinatorDelegate?
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let userService = DefaultUserService()
        let userRepository = DefaultUserRepository(service: userService)
        let loginUseCase = DefaultLoginUseCase(repository: userRepository)
        let viewModel = LoginViewModel(loginUseCase: loginUseCase)
        let loginViewController = LoginViewController(viewModel: viewModel)
        loginViewController.delegate = self
        navigationController.setViewControllers([loginViewController], animated: true)
    }
}

extension LoginCoordinator: LoginViewControllerDelegate {
    func didCompleteLogin() {
        let onboardingViewController = OnboardingViewController()
        onboardingViewController.delegate = self
        navigationController.pushViewController(onboardingViewController, animated: true)
    }
}

extension LoginCoordinator: OnboardingViewControllerDelegate {
    func didCompleteOnBoarding() {
        delegate?.didCompleteOnBoarding(self)
    }
}
