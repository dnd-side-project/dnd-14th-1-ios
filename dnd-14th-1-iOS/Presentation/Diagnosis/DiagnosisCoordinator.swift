//
//  DiagnosisCoordinator.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/14/26.
//

import UIKit

protocol DiagnosisViewControllerDelegate: AnyObject {
    func didTapPromptButton()
}

protocol PromptLoadingViewControllerDelegate: AnyObject {
    func didCompleteDiagnosis()
}

final class DiagnosisCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let diagnosisViewController = DiagnosisViewController()
        diagnosisViewController.delegate = self
        navigationController.pushViewController(diagnosisViewController, animated: true)
    }
}

extension DiagnosisCoordinator: DiagnosisViewControllerDelegate {
    func didTapPromptButton() {
        let promptLoadingViewController = PromprtLoadingViewController()
        promptLoadingViewController.hidesBottomBarWhenPushed = true
        promptLoadingViewController.delegate = self
        navigationController.pushViewController(promptLoadingViewController, animated: true)
    }
}

extension DiagnosisCoordinator: PromptLoadingViewControllerDelegate {
    func didCompleteDiagnosis() {
        let promprtResultViewController = PromptDiagnosisViewController()
        promprtResultViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(promprtResultViewController, animated: true)
    }
}
