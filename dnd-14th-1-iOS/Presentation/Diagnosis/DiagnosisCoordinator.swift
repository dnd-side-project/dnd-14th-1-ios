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
    func didCompleteLoading(_ loadingType: PromprtLoadingViewController.PromptLoadingType)
}

protocol DiagnosisResultViewControllerDelegate: AnyObject {
    func promptEditButtonTapped()
}

final class DiagnosisCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let diagnosisViewController = DiagnosisViewController(viewModel: DiagnosisViewModel())
        diagnosisViewController.delegate = self
        navigationController.pushViewController(diagnosisViewController, animated: true)
    }
}

extension DiagnosisCoordinator: DiagnosisViewControllerDelegate {
    func didTapPromptButton() {
        let promptLoadingViewController = PromprtLoadingViewController(
            title: "작성하신 프롬프트를 진단하고 있어요...",
            description: "진단 결과에 따라 빙하의 운명이 결정돼요!",
            loadingType: .diagnose
        )
        promptLoadingViewController.hidesBottomBarWhenPushed = true
        promptLoadingViewController.delegate = self
        navigationController.pushViewController(promptLoadingViewController, animated: true)
    }
}

extension DiagnosisCoordinator: PromptLoadingViewControllerDelegate {
    func didCompleteLoading(_ loadingType: PromprtLoadingViewController.PromptLoadingType) {
        switch loadingType {
        case .diagnose:
            let promprtResultViewController = DiagnosisResultViewController()
            promprtResultViewController.delegate = self
            promprtResultViewController.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(promprtResultViewController, animated: true)
        case .imporve:
            let promptImproveViewController = PromptImprovedViewController()
            promptImproveViewController.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(promptImproveViewController, animated: true)
        }
    }
}

extension DiagnosisCoordinator: DiagnosisResultViewControllerDelegate {
    func promptEditButtonTapped() {
        let promptLoadingViewController = PromprtLoadingViewController(
            title: "북극곰의 발판을 더 단단하게 다듬는 중...",
            description: "문장을 수정하여 최적화된 프롬프트를 만들어요!",
            loadingType: .imporve
        )
        promptLoadingViewController.hidesBottomBarWhenPushed = true
        promptLoadingViewController.delegate = self
        navigationController.pushViewController(promptLoadingViewController, animated: true)
    }
}
