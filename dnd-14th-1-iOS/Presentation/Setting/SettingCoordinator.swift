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
        let userService = DefaultUserService()
        let userRepository = DefaultUserRepository(service: userService)
        let fetchUserProfileUseCase = DefaultFetchUserProfileUseCase(repository: userRepository)
        let fetchBadgeListUseCase = DefaultFetchMyBadgesUseCase(repository: userRepository)
        let logoutUseCase = DefaultLogoutUseCase()
        let changeRepresentativeBadgeUseCase = DefaultUpdateRepresentativeBadgeUseCase(repository: userRepository)
        let settingViewModel = SettingViewModel(
            fetchUserProfileUseCase: fetchUserProfileUseCase,
            fetchMyBadgesUseCase: fetchBadgeListUseCase,
            logoutUseCase: logoutUseCase,
            changeRepresentativeBadge: changeRepresentativeBadgeUseCase)
        let settingViewController = SettingViewController(viewModel: settingViewModel)
        settingViewController.delegate = self
        navigationController.pushViewController(settingViewController, animated: true)
    }
}

extension SettingCoordinator: SettingViewControllerDelegate {
    
    func navigateToTermsOfUse() {
        let termsOfUseViewController = TermsOfUseViewController()
        navigationController.pushViewController(termsOfUseViewController, animated: true)
    }
    
    func navigateToPrivacyPolicy() {
        let privacyPolicyViewController = PrivacyPolicyViewController()
        navigationController.pushViewController(privacyPolicyViewController, animated: true)
    }
}
