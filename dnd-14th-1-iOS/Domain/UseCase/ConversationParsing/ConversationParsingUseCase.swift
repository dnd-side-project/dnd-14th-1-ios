//
//  ConversationParsingUseCase.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/26/26.
//

protocol ConversationParsingUseCase {
    func execute(promptInput: PromptInput) async throws -> PromptDiagnosis
}

final class DefaultConversationParsingUseCase: ConversationParsingUseCase {
    
    private let conversationRepository: ConversationRepository
    
    init(conversationRepository: ConversationRepository) {
        self.conversationRepository = conversationRepository
    }
    
    func execute(promptInput: PromptInput) async throws -> PromptDiagnosis {
        try await conversationRepository.fetchConversations()
        return .init(
            efficiency: .efficiency,
            meltedGlacierAmount: 0,
            inputToken: 0,
            outputToken: 0,
            estimatedLoss: 0,
            originalPrompt: promptInput.value,
            usingModel: .claude_haiku_4_5,
            source: .url,
            sentences: []
        )
    }
}


