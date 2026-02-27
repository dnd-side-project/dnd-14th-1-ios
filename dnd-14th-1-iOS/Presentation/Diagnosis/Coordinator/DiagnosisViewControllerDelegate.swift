//
//  DiagnosisViewControllerDelegate.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/24/26.
//


protocol DiagnosisViewControllerDelegate: AnyObject {
    func didTapPromptButton()
    func startDiagnosis()
    func completeDiagnosis(_ promptDiagnosis: PromptDiagnosisResult)
    func failDiagnosis()
}

protocol PromptLoadingViewControllerDelegate: AnyObject {    
}

protocol DiagnosisResultViewControllerDelegate: AnyObject {
    func promptEditButtonTapped()
    func completeButtonTapped()
    func homeButtonTapped()
    func startPromptImprovement()
    func completePromptImprovement(promt: String, result: PromptImproveResult)
    func failPromptImprovement()
}

protocol PromptImprovedViewControllerDelegate: AnyObject {
    func promptHomeButtonTapped()
}
