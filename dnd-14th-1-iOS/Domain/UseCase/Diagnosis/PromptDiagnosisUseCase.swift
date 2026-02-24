//
//  PromptDiagnosisUseCase.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/24/26.
//

import FoundationModels
import Foundation
import Combine

protocol PromptDiagnosisUseCase {
    func excute(promptInput: PromptInput) async throws -> PromptDiagnosis
}

final class DefaultPromptDiagnosisUseCase: PromptDiagnosisUseCase {
    
    func excute(promptInput: PromptInput) async throws -> PromptDiagnosis  {
        do {
            let instructions = """
                Your task is to evaluate the prompt provided by the user.            
                """
            
            let session = LanguageModelSession(instructions: instructions)
            let prompt = promptInput.value
            let response = try await session.respond(to: prompt, generating: PromptDiagnosis.self)
            
            let result = PromptDiagnosis(
                efficiency: response.content.efficiency,
                meltedGlacierAmount: response.content.meltedGlacierAmount,
                tokenUsage: response.content.tokenUsage,
                estimatedLoss: response.content.estimatedLoss
            )
            
            return result
        } catch {
            throw error
        }
    }
}
