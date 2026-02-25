//
//  DiagnosisViewControllerDelegate.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/24/26.
//


protocol DiagnosisViewControllerDelegate: AnyObject {
    func didTapPromptButton()
    func startDiagnosis()
    func completeDiagnosis(_ promptDiagnosis: PromptDiagnosis)
    func failDiagnosis()
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
