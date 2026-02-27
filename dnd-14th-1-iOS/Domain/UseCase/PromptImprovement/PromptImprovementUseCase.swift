//
//  PromptImprovementUseCase.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/26/26.
//

import Foundation
import FoundationModels

protocol PromptImprovementUseCase {
    func execute(promptDiagnosis: PromptDiagnosisResult) async throws -> PromptImproveResult
}

final class DefaultPromptImprovementUseCase: PromptImprovementUseCase {
    
    private let claudeService: ClaudeService
    
    init(claudeService: ClaudeService) {
        self.claudeService = claudeService
    }
    
    func execute(promptDiagnosis: PromptDiagnosisResult) async throws -> PromptImproveResult {
        var sentences: [PromptSentence] = []
        
        let originalPrompt = promptDiagnosis.originalPrompt
        var improvedPrompt = ""
        
        for sentence in promptDiagnosis.sentences {
            // 프롬프트 개선
            let session = LanguageModelSession(instructions: Instruction.improvePrompt)
            let response = try await session.respond(to: "아래 프롬프트 문장을 더 명확하고 효과적으로 개선해주세요.\n\(sentence)", generating: ImprovedPrompt.self)
            
            // 개선된 프롬프트 범위 지정
            guard let improvementRange = originalPrompt.range(of: sentence) else { continue }
            
            // 프롬프트 개선
            improvedPrompt = originalPrompt.replacingCharacters(in: improvementRange, with: response.content.improvedPrompt)
            
            // 결과에 저장
            sentences.append(
                PromptSentence(
                    improvementRange: improvementRange,
                    originalPrompt: sentence,
                    improvedPrompt: response.content.improvedPrompt,
                    reason: response.content.reason
                )
            )
        }
        
        // 토큰 카운팅
        let totalTokenUsage = try await claudeService.request(for: improvedPrompt).usage
        let improvedPromptTokenCount = (totalTokenUsage?.input_tokens ?? 0) + (totalTokenUsage?.output_tokens ?? 0)
        let originalPromptTokenCount = promptDiagnosis.inputToken + promptDiagnosis.outputToken
        let savedToken = originalPromptTokenCount - improvedPromptTokenCount
        
        return PromptImproveResult(sentences: sentences, savedToken: savedToken)
    }
}


