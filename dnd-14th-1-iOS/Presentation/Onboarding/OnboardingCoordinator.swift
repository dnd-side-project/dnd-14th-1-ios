//
//  OnboardingCoordinator.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/16/26.
//

import UIKit

protocol OnboardingViewControllerDelegate: AnyObject {
    func didCompleteOnBoarding()
}

final class OnboardingCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let onboardingViewController = OnboardingViewController()
        navigationController.pushViewController(onboardingViewController, animated: true)
    }
}
