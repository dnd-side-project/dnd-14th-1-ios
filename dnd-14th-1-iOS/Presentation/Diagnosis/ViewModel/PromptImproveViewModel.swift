//
//  PromptImproveViewModel.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/27/26.
//

import Combine
import Foundation

final class PromptImproveViewModel: ViewModelType {
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
    }
    
    // MARK: - Output
    
    enum Output {
        case showPromptImprovement(PromptImproveResult)
    }
    
    private let outputSubject = PassthroughSubject<Output, Never>()
    private let promptImproveResult: PromptImproveResult
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(promptImproveResult: PromptImproveResult) {
        self.promptImproveResult = promptImproveResult
    }
    
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .receive(on: DispatchQueue.main)
            .sink { [weak self] input in
                guard let self else { return }
                switch input {
                case .viewDidLoad:
                    outputSubject.send(.showPromptImprovement(promptImproveResult))
                }
            }
            .store(in: &subscriptions)
        return outputSubject.eraseToAnyPublisher()
    }
}
