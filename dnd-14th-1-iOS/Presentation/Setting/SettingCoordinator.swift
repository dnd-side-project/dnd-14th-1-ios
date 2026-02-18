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
        let mockFetchUserProfileUseCase = MockFetchUserProfileUseCase()
        let mockFetchBadgeListUseCase = MockFetchBadgeListUseCase()
        let defualtLogoutUseCase = DefaultLogoutUseCase()
        let settingViewModel = SettingViewModel(fetchUserProfileUseCase: mockFetchUserProfileUseCase, fetchBadgeListUseCase: mockFetchBadgeListUseCase, logoutUseCase: defualtLogoutUseCase)
        let settingViewController = SettingViewController(viewModel: settingViewModel)
        settingViewController.coordinator = self
        navigationController.pushViewController(settingViewController, animated: true)
    }
    
    func navigateToTermsOfUse() {
        let termsOfUseViewController = TermsOfUseViewController()
        navigationController.pushViewController(termsOfUseViewController, animated: true)
    }
    
    func navigateToPrivacyPolicy() {
        let privacyPolicyViewController = PrivacyPolicyViewController()
        navigationController.pushViewController(privacyPolicyViewController, animated: true)
    }
}
