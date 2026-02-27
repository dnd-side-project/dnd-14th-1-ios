//
//  DiagnosisViewControllerDelegate.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/24/26.
//


protocol DiagnosisViewControllerDelegate: AnyObject {
    func didTapPromptButton()
    func startDiagnosis()
    func completeDiagnosis(_ promptDiagnosis: PromptDiagnosisResult, _ glacierGrade: GlacierGrade)
    func failDiagnosis()
}

protocol PromptLoadingViewControllerDelegate: AnyObject {    
}

protocol DiagnosisResultViewControllerDelegate: AnyObject {
    func promptEditButtonTapped()
    func completeButtonTapped()
    func homeButtonTapped()
    func startPromptImprovement()
    func completePromptImprovement(result: PromptImproveResult)
    func failPromptImprovement()
}

protocol PromptImprovedViewControllerDelegate: AnyObject {
    func promptHomeButtonTapped()
}
