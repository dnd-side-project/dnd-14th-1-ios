//
//  PromptImprovementUseCase.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/26/26.
//

import FoundationModels

protocol PromptImprovementUseCase {
    func execute(promptDiagnosis: PromptDiagnosis) async throws -> [ImprovePromptResult]
}

final class DefaultPromptImprovementUseCase: PromptImprovementUseCase {
    func execute(promptDiagnosis: PromptDiagnosis) async throws -> [ImprovePromptResult] {
        let instructions = """
    당신은 사용자가 입력한 프롬프트를 구체적이고 상세하고 효율적인 프롬프트로 개선합니다.
    
    [평가 항목]
    clarity:
    - AI에게 특정 작업을 수행하라는 명령/요청 문장이 있는가?
    - 반드시 동사 기반 작업 요청이 있어야 1점입니다.
    - 단순 응답, 감탄사, 단어 하나는 0점입니다.
    
    specificity:
    - 원하는 결과 형태가 구체적으로 명시되어 있는가?
    
    context:
    - 작업 수행에 필요한 배경 정보가 제공되는가?
    
    goalOrientation:
    - 최종적으로 얻고자 하는 결과가 명확한가?
    """
        
        var results: [ImprovePromptResult] = []
        
        for sentence in promptDiagnosis.sentences {
            let session = LanguageModelSession(instructions: instructions)
            let response = try await session.respond(
                to: "아래 프롬프트 문장을 더 명확하고 효과적으로 개선해주세요.\n\(sentence)",
                generating: ImprovedPrompt.self
            )
            results.append(ImprovePromptResult(originalPrompt: sentence, improvedPrompt: response.content.improvedPrompt, reason: response.content.reason))
        }
        
        return results
    }
}


