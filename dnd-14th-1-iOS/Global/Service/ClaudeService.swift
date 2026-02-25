//
//  ClaudeService.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/25/26.
//

import Alamofire

import Alamofire

protocol ClaudeService {
    func request(for prompt: String) async throws -> ClaudeMessageResponse
    func calculateCost(
        usingModel: ClaudeModel,
        inputTokens: Int,
        outputTokens: Int
    ) -> Double
}

enum ClaudeModel {
    case claude_haiku_4_5
    
    var inputTokenPermillion: Double {
        switch self {
        case .claude_haiku_4_5:
            1
        }
    }
    
    var outputTokenPermillion: Double {
        switch self {
        case .claude_haiku_4_5:
            5
        }
    }
}

final class DefaultClaudeService: ClaudeService {
    
    // MARK: - Properties
    
    private let requestURL = "https://api.anthropic.com/v1/messages"
    private let model = "claude-haiku-4-5"
    
    private var headers: HTTPHeaders {
        [
            "Content-Type": "application/json",
            "x-api-key": AppConfig.caludeApiKey,
            "anthropic-version": "2023-06-01"
        ]
    }
    
    func request(for prompt: String) async throws -> ClaudeMessageResponse {
        
        let parameters = ClaudeMessageRequest(
            model: model,
            max_tokens: 1000,
            messages: [
                ClaudeMessage(
                    role: "user",
                    content: prompt
                )
            ]
        )
        
        return try await AF.request(
            requestURL,
            method: .post,
            parameters: parameters,
            encoder: JSONParameterEncoder.default,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .serializingDecodable(ClaudeMessageResponse.self)
        .value
    }
    
    func calculateCost(
        usingModel: ClaudeModel,
        inputTokens: Int,
        outputTokens: Int
    ) -> Double {
        var inputCost = 0.0
        var outputCost = 0.0
        
        switch usingModel {
        case .claude_haiku_4_5:
            inputCost = (Double(inputTokens) / 1_000_000) * usingModel.inputTokenPermillion
            outputCost = (Double(outputTokens) / 1_000_000) * usingModel.outputTokenPermillion
        }
        return inputCost + outputCost
    }
}
