//
//  DiagnosisCoordinator.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/14/26.
//

import UIKit

final class DiagnosisCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let claudeService = DefaultClaudeService()
        let promptDiagnosisUseCase = DefaultPromptDiagnosisUseCase(claudeService: claudeService)
        let diagnosisViewModel = DiagnosisViewModel(promptDiagnosisUseCase: promptDiagnosisUseCase)
        let diagnosisViewController = DiagnosisViewController(viewModel: diagnosisViewModel)
        diagnosisViewController.delegate = self
        navigationController.pushViewController(diagnosisViewController, animated: true)
    }
}

// MARK: - DiagnosisDelegate

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
    
    func failDiagnosis() {
        var viewControllers = navigationController.viewControllers
        viewControllers.removeLast()
        
        let errorViewController = ErrorViewController(
            title: "진단하는 과정에서 오류가 발생했어요",
            description: "프롬프트를 다시 한번 확인해 주시겠어요?"
        )
        
        errorViewController.hidesBottomBarWhenPushed = true
        viewControllers.append(errorViewController)
        navigationController.setViewControllers(viewControllers, animated: true)
    }
    
    func startDiagnosis() {
        let promptLoadingViewController = PromptLoadingViewController(
            title: "작성하신 프롬프트를 진단하고 있어요...",
            description: "진단 결과에 따라 빙하의 운명이 결정돼요!",
            loadingType: .diagnose
        )
        promptLoadingViewController.hidesBottomBarWhenPushed = true
        promptLoadingViewController.delegate = self
        
        navigationController.pushViewController(promptLoadingViewController, animated: true)
    }
    
    func completeDiagnosis(_ promptDiagnosis: PromptDiagnosis) {
        var viewControllers = navigationController.viewControllers
        viewControllers.removeLast()
        
        let diagnosisResultViewModel = DiagnosisResultViewModel(promptDiagnosisResult: promptDiagnosis)
        
        let promprtResultViewController = DiagnosisResultViewController(viewModel: diagnosisResultViewModel)
        promprtResultViewController.delegate = self
        promprtResultViewController.hidesBottomBarWhenPushed = true
        promprtResultViewController.backButtonColor = .commonWhite
        
        viewControllers.append(promprtResultViewController)
        navigationController.setViewControllers(viewControllers, animated: true)
    }
}

// MARK: - DiagnosisLoadingDelegate

extension DiagnosisCoordinator: PromptLoadingViewControllerDelegate {
    func didCompleteLoading(_ loadingType: PromptLoadingViewController.PromptLoadingType) {
//        var viewControllers = navigationController.viewControllers
//        viewControllers.removeLast()
//        
//        switch loadingType {
//        case .diagnose:
//            let promprtResultViewController = DiagnosisResultViewController()
//            promprtResultViewController.delegate = self
//            promprtResultViewController.hidesBottomBarWhenPushed = true
//            promprtResultViewController.backButtonColor = .commonWhite
//            
//            viewControllers.append(promprtResultViewController)
//            navigationController.setViewControllers(viewControllers, animated: true)
//        case .improve:
//            let promptImproveViewController = PromptImprovedViewController()
//            promptImproveViewController.delegate = self
//            promptImproveViewController.hidesBottomBarWhenPushed = true
//            viewControllers.append(promptImproveViewController)
//            navigationController.setViewControllers(viewControllers, animated: true)
//        }
    }
}

// MARK: - DiagnosisResultDelegate

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
