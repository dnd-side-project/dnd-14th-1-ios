//
//  DiagnosisResultViewModel.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/25/26.
//

import Combine

final class DiagnosisResultViewModel: ViewModelType {
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
    }
    
    // MARK: - Output
    
    enum Output {
        case displayDiagnosisResult(PromptDiagnosis)
    }
    
    private let outputSubject = PassthroughSubject<Output, Never>()
    private let promptDiagnosis: PromptDiagnosis
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(promptDiagnosisResult: PromptDiagnosis) {
        self.promptDiagnosis = promptDiagnosisResult
    }
    
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] input in
            guard let self else { return }
            switch input {
            case .viewDidLoad:
                displayDiagnosisResult()
            }
        }
        .store(in: &subscriptions)
        
        return outputSubject.eraseToAnyPublisher()
    }
    
    func displayDiagnosisResult() {
        outputSubject.send(.displayDiagnosisResult(promptDiagnosis))
    }
}
