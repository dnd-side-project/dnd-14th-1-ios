//
//  MyEcoCoordinator.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/14/26.
//

import UIKit

final class MyEcoCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let ecoRepository = DefaultEcoRepository(service: DefaultEcoService())
        let userRepository = DefaultUserRepository(service: DefaultUserService())
        let fetchEcoTierUseCase = DefaultFetchEcoTierUseCase(ecoRepository: ecoRepository)
        let fetchMyBadgesUseCase = DefaultFetchMyBadgesUseCase(repository: userRepository)
        let ecoViewModel = EcoViewModel(
            fetchEcoTierUseCase: fetchEcoTierUseCase,
            fetchMyBadgesUseCase: fetchMyBadgesUseCase
        )
        let ecoViewController = EcoViewController(viewModel: ecoViewModel)
        ecoViewController.delegate = self
        navigationController.pushViewController(ecoViewController, animated: true)
    }
}

extension MyEcoCoordinator: EcoViewControllerDelegate {
    
    func presentShareTier(tier: EcoTier) {
        let kakaoShareUseCase = DefaultKakaoShareUseCase()
        let shareTierModalViewController = ShareTierModalViewController(
            tier: tier,
            kakaoShareUseCase: kakaoShareUseCase
        )
        shareTierModalViewController.modalPresentationStyle = .overFullScreen
        shareTierModalViewController.modalTransitionStyle = .crossDissolve
        navigationController.present(shareTierModalViewController, animated: true)
    }
    
    func presentShareBadge(badge: Badge) {
        let kakaoShareUseCase = DefaultKakaoShareUseCase()
        let shareBadgeModalViewController = ShareBadgeModalViewController(
            badge: badge,
            kakaoShareUseCase: kakaoShareUseCase
        )
        shareBadgeModalViewController.modalPresentationStyle = .overFullScreen
        shareBadgeModalViewController.modalTransitionStyle = .crossDissolve
        navigationController.present(shareBadgeModalViewController, animated: true)
    }    
}

