//
//  EfficiencyType.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/25/26.
//

import FoundationModels

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
