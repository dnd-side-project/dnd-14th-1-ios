//
//  PromptDiagnosis.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/25/26.
//

import FoundationModels

enum PromptSource {
    case singlePrompt
    case url
}

struct PromptDiagnosis {
    let efficiency: EfficiencyType
    let meltedGlacierAmount: Double    
    let inputToken: Int
    let outputToken: Int
    let estimatedLoss: Double
    let originalPrompt: String
    let usingModel: ClaudeModel
    let source: PromptSource
    let sentences: [Sentence]
}
