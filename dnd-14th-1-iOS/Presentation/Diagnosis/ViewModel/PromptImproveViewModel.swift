//
//  PromptImproveViewModel.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/27/26.
//

import Combine

final class PromptImproveViewModel: ViewModelType {
    // MARK: - Input
    
    enum Input {}
    
    // MARK: - Output
    
    enum Output {}
    
    private let outputSubject = PassthroughSubject<Output, Never>()
    private let promptImproveResult: [ImprovePromptResult]
    private let originalPrompt: String
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(promptImproveResult: [ImprovePromptResult], originalPrompt: String) {
        self.promptImproveResult = promptImproveResult
        self.originalPrompt = originalPrompt
    }
    
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        return outputSubject.eraseToAnyPublisher()
    }
}
