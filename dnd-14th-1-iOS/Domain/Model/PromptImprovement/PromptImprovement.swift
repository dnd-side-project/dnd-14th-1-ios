//
//  PromptImprovement.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/26/26.
//

import FoundationModels

@Generable
struct ImprovedSentences {
    let originalSentence: String
    let improvedSetence: String
}

@Generable
struct ImprovedPrompt {
    @Guide(description: "개선된 프롬프트 문장")
    var improvedPrompt: String
    @Guide(description: "프롬프트 수정한 이유를 상세하게 설명합니다.")
    var reason: String
}

@Generable
struct ImprovedPromptList {
    @Guide(description: "개선된 프롬프트 목록")
    var items: [ImprovedPrompt]
}

struct ImprovePromptResult {
    let originalPrompt: String
    let improvedPrompt: String
    let reason: String
}
