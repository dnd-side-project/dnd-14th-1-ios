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
                Your task is to evaluate the prompt provided by the user.            
                """
            
            let session = LanguageModelSession(instructions: instructions)
            
            let diagnosisResponse = try await session.respond(to: prompt, generating: EfficiencyType.self)
            
            let inputToken = tokenUsage.input_tokens ?? 0
            let outputToken = tokenUsage.output_tokens ?? 0
            let estimatedLoss = claudeService.calculateCost(
                usingModel: .claude_haiku_4_5,
                inputTokens: inputToken,
                outputTokens: outputToken
            )            
            
            let result = PromptDiagnosis(
                efficiency: diagnosisResponse.content,
                meltedGlacierAmount: -0.75,
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
}
