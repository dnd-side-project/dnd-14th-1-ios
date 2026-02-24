//
//  DiagnosisCoordinator.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/14/26.
//

import UIKit

// MARK: - ViewController Delegate

protocol DiagnosisViewControllerDelegate: AnyObject {
    func didTapPromptButton()
}

protocol PromptLoadingViewControllerDelegate: AnyObject {
    func didCompleteLoading(_ loadingType: PromptLoadingViewController.PromptLoadingType)
}

protocol DiagnosisResultViewControllerDelegate: AnyObject {
    func promptEditButtonTapped()
    func homeButtonTapped()
}

protocol PromptImprovedViewControllerDelegate: AnyObject {
    func promptHomeButtonTapped()
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
        let promptLoadingViewController = PromptLoadingViewController(
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
    func didCompleteLoading(_ loadingType: PromptLoadingViewController.PromptLoadingType) {
        var viewControllers = navigationController.viewControllers
        viewControllers.removeLast()
        
        switch loadingType {
        case .diagnose:
            let promprtResultViewController = DiagnosisResultViewController()
            promprtResultViewController.delegate = self
            promprtResultViewController.hidesBottomBarWhenPushed = true
            promprtResultViewController.backButtonColor = .commonWhite
            
            viewControllers.append(promprtResultViewController)
            navigationController.setViewControllers(viewControllers, animated: true)
        case .improve:
            let promptImproveViewController = PromptImprovedViewController()
            promptImproveViewController.delegate = self
            promptImproveViewController.hidesBottomBarWhenPushed = true
            viewControllers.append(promptImproveViewController)
            navigationController.setViewControllers(viewControllers, animated: true)
        }
    }
}

extension DiagnosisCoordinator: DiagnosisResultViewControllerDelegate {
    func promptEditButtonTapped() {
        let promptLoadingViewController = PromptLoadingViewController(
            title: "북극곰의 발판을 더 단단하게 다듬는 중...",
            description: "문장을 수정하여 최적화된 프롬프트를 만들어요!",
            loadingType: .improve
        )
        promptLoadingViewController.hidesBottomBarWhenPushed = true
        promptLoadingViewController.delegate = self
        navigationController.pushViewController(promptLoadingViewController, animated: true)
    }
    
    func homeButtonTapped() {
        navigationController.popToRootViewController(animated: true)
    }
}

extension DiagnosisCoordinator: PromptImprovedViewControllerDelegate {
    func promptHomeButtonTapped() {
        navigationController.popToRootViewController(animated: true)
    }
}
