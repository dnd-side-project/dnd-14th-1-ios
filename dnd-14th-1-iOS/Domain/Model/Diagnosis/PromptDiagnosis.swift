//
//  PromptDiagnosis.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/25/26.
//

import FoundationModels

@Generable(description: "Diagnose the given prompt and return its efficiency (efficiency or inefficiency), melted glacier amount, token usage, and estimated loss.")
struct PromptDiagnosis {
    @Generable(description: """
            Your task is to evaluate the prompt provided by the user.

            Determine whether it is 'efficiency' or 'inefficiency' based on the following criteria:
            - Clarity
            - Specificity
            - Context
            - Goal-orientation

            If the prompt satisfies at least two of these criteria, return 'efficiency'.
            Otherwise, return 'inefficiency'.

            Also generate meltedGlacierAmount (Double), tokenUsage (Int), and estimatedLoss (Double).
            meltedGlacierAmount and estimatedLoss should increase proportionally with tokenUsage.
            Return realistic and internally consistent values.
    """)
    enum EfficiencyType {
        case efficiency
        case inefficiency
    }
    
    let efficiency: EfficiencyType
    @Guide(description: "Return the amount of melted glacier. This value must increase as tokenUsage increases.")
    let meltedGlacierAmount: Double

    @Guide(description: "Calculate the number of tokens using the Apple Intelligence tokenizer. Ensure that identical inputs always return identical token counts.")
    let tokenUsage: Int

    @Guide(description: "Return the estimated cost. This value must increase proportionally with tokenUsage.")
    let estimatedLoss: Double
}
