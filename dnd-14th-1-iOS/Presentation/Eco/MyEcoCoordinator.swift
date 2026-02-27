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
        let fetchEcoTierUseCase = MockFetchEcoTierUseCase()
        let fetchMyBadgesUseCase = MockFetchMyBadgesUseCase()
        let ecoViewModel = EcoViewModel(
            fetchEcoTierUseCase: fetchEcoTierUseCase,
            fetchMyBadgesUseCase: fetchMyBadgesUseCase
        )
        let ecoViewController = EcoViewController(viewModel: ecoViewModel)
        navigationController.pushViewController(ecoViewController, animated: true)
    }
}
