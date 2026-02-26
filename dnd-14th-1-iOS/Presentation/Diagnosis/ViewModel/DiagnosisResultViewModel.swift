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
        case success
        case failure
    }
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
        case promptImproveButtonTapped
    }
    
    // MARK: - Output
    
    enum Output {
        case displayDiagnosisResult(PromptDiagnosis)
        case promptImproveStateChanged(PromptImproveState)
    }
    
    private let promptImprovementUseCase: PromptImprovementUseCase
    private let outputSubject = PassthroughSubject<Output, Never>()
    private let promptDiagnosis: PromptDiagnosis
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(
        promptDiagnosisResult: PromptDiagnosis,
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
            try await Task.sleep(for: .seconds(3))
            await promptImprovementUseCase.execute()
            outputSubject.send(.promptImproveStateChanged(.success))
        }
    }
}
