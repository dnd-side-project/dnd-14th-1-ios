//
//  PromptDiagnosisUseCase.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/24/26.
//

import FoundationModels
import Foundation
import Combine
import Alamofire

enum PromptDiagnosisError: Error {
    case apiError
}

protocol PromptDiagnosisUseCase {
    func excute(promptInput: PromptInput) async throws -> PromptDiagnosis
}

final class DefaultPromptDiagnosisUseCase: PromptDiagnosisUseCase {
    
    private let claudeService: ClaudeService
    
    init(claudeService: ClaudeService) {
        self.claudeService = claudeService
    }
    
    func excute(promptInput: PromptInput) async throws -> PromptDiagnosis  {
        do {
            let prompt = promptInput.value
            
            guard let tokenUsage = try await claudeService.request(for: prompt).usage else {
                throw PromptDiagnosisError.apiError
            }
            
            let instructions = """
            당신은 프롬프트 품질을 진단하는 매우 엄격한 평가자입니다.
            """
            
            let session = LanguageModelSession(instructions: instructions)
            
            let diagnosisResponse = try await session.respond(to: prompt, generating: PromptEvaluation.self)
            
            let efficiency = diagnosisResponse.content.efficiency
            
            let inputToken = tokenUsage.input_tokens ?? 0
            let outputToken = tokenUsage.output_tokens ?? 0
            let totalToken = inputToken + outputToken
            let estimatedLoss = claudeService.calculateCost(
                usingModel: .claude_haiku_4_5,
                inputTokens: inputToken,
                outputTokens: outputToken
            )
            let meltedGlacierAmount = calculateMeltedGlacierAmount(tokenUsage: totalToken)
            
            let result = PromptDiagnosis(
                efficiency: efficiency,
                meltedGlacierAmount: meltedGlacierAmount,
                inputToken: inputToken,
                outputToken: outputToken,
                estimatedLoss: estimatedLoss * 1432.19,
                originalPrompt: prompt
            )
            
            return result
        } catch {
            throw error
        }
    }
    
    func calculateMeltedGlacierAmount(tokenUsage: Int) -> Double {
        return (Double(tokenUsage) / 1000.0) * 0.02
    }
}
