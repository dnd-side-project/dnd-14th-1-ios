//
//  ClaudeService.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/25/26.
//

import Alamofire
import Foundation

protocol ClaudeService {
    func request(for prompt: String) async throws -> ClaudeMessageResponse
    func calculateCost(
        usingModel: ClaudeModel,
        inputTokens: Int,
        outputTokens: Int
    ) -> Double
    func splitPromptIntoSentences(_ prompt: String) async throws -> [String]
    var model: ClaudeModel { get }
}

enum ClaudeModel {
    case claude_haiku_4_5
    
    var inputTokenPermillion: Double {
        switch self {
            case .claude_haiku_4_5: 1 }
    }
    
    var outputTokenPermillion: Double {
        switch self {
            case .claude_haiku_4_5: 5 }
    }
    
    var modelName: String {
        switch self {
            case .claude_haiku_4_5: "Claude Haiku 4.5" }
    }
    
    var modelApiId: String {
        switch self {
            case .claude_haiku_4_5: "claude-haiku-4-5" }
    }
}

final class DefaultClaudeService: ClaudeService {
    
    // MARK: - Properties
    
    private let requestURL = "https://api.anthropic.com/v1/messages"
    
    private(set) var model : ClaudeModel
    
    private var headers: HTTPHeaders {
        [
            "Content-Type": "application/json",
            "x-api-key": AppConfig.claudeApiKey,
            "anthropic-version": "2023-06-01"
        ]
    }
    
    init(model: ClaudeModel) {
        self.model = model
    }
    
    func request(for prompt: String) async throws -> ClaudeMessageResponse {
        
        let parameters = ClaudeMessageRequest(
            model: model.modelApiId,
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
    
    func splitPromptIntoSentences(_ prompt: String) async throws -> [String] {
        let parameters = ClaudeMessageRequest(
            model: model.modelApiId,
            max_tokens: 1000,
            messages: [
                ClaudeMessage(
                    role: "user",
                    content: "\(ClaudeInstructions.splitPromptIntoSentences) 사용자 프롬프트: \(prompt)"
                )
            ],            
            output_config: OutputConfig(
                format: OutputFormat(
                    type: "json_schema",
                    schema: JSONSchema(
                        type: "object",
                        properties: ["sentences":SchemaProperty(type: "array", items: SchemaItems(type: "string"))],
                        required: ["setences"],
                        additionalProperties: false
                    )
                )
            )
        )
        
        let response = try await AF.request(
            requestURL,
            method: .post,
            parameters: parameters,
            encoder: JSONParameterEncoder.default,
            headers: headers
        )
            .validate(statusCode: 200..<300)
            .serializingDecodable(ClaudeResponse.self)
            .value
        
        let jsonText = response.content[0].text ?? ""
        let result = try JSONDecoder().decode(SplitResult.self, from: Data(jsonText.utf8))
            
        return result.sentences
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

struct SplitResult: Decodable {
    let sentences: [String]
}
