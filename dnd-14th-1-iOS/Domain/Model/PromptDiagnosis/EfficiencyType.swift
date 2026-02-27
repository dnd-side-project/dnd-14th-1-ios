//
//  EfficiencyType.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/25/26.
//

import FoundationModels

@Generable()
enum EfficiencyType {
    case inefficiency
    case efficiency
}

@Generable(description: """
당신은 매우 엄격한 프롬프트 품질 평가사입니다.

다음 항목을 0 또는 1로 평가하세요.

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

엄격한 규칙:
- 작업 지시 동사가 없으면 clarity는 반드시 0.
- 한 단어 입력은 모든 항목 0.
- 절대 관대하게 해석하지 마세요.

각 항목은 반드시 0 또는 1로만 반환하세요.

reason에는 각 항목에 대해 왜 그렇게 판단했는지 간단히 설명하세요.
""")
struct PromptEvaluation {
    let clarity: Int
    let specificity: Int
    let context: Int
    let goalOrientation: Int
    @Guide(description: "clarity, specificity, context, goalOrientation 각각에 대한 판단 이유")
    let reason: String
}

struct Sentence {
    @Guide(description: "사용자가 입력한 문장")
    let sentence: String
    let clarity: Int
    let specificity: Int
    let context: Int
    let goalOrientation: Int
}

extension PromptEvaluation {
    var totalScore: Int {
        clarity + specificity + context + goalOrientation
    }
    
    var efficiency: EfficiencyType {
        totalScore >= 3 ? .efficiency : .inefficiency
    }
}

