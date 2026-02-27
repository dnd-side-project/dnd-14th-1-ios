//
//  DiagnosisResultViewModel.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/25/26.
//

import Combine

final class DiagnosisResultViewModel: ViewModelType {
    // MARK: - State
    enum PromptImproveState {
        case loading
        case success(prompt: String, result: PromptImproveResult)
        case failure
    }
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
        case promptImproveButtonTapped
    }
    
    // MARK: - Output
    
    enum Output {
        case displayDiagnosisResult(PromptDiagnosisResult)
        case promptImproveStateChanged(PromptImproveState)
    }
    
    private let promptImprovementUseCase: PromptImprovementUseCase
    private let outputSubject = PassthroughSubject<Output, Never>()
    private let promptDiagnosis: PromptDiagnosisResult
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(
        promptDiagnosisResult: PromptDiagnosisResult,
        promptImprovementUseCase: PromptImprovementUseCase
    ) {
        self.promptDiagnosis = promptDiagnosisResult
        self.promptImprovementUseCase = promptImprovementUseCase
    }
    
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] input in
            guard let self else { return }
            switch input {
            case .viewDidLoad:
                displayDiagnosisResult()
            case .promptImproveButtonTapped:
                promptImprovement()
            }
        }
        .store(in: &subscriptions)
        
        return outputSubject.eraseToAnyPublisher()
    }
    
    func displayDiagnosisResult() {
        outputSubject.send(.displayDiagnosisResult(promptDiagnosis))
    }
    
    func promptImprovement() {
        outputSubject.send(.promptImproveStateChanged(.loading))
        
        Task {
            let response = try await promptImprovementUseCase.execute(promptDiagnosis: promptDiagnosis)
            outputSubject.send(.promptImproveStateChanged(.success(prompt: promptDiagnosis.originalPrompt, result: response)))
        }
    }
}
