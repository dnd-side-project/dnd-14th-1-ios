//
//  ClaudeMessageResponse.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/25/26.
//

import Foundation

struct ClaudeMessageResponse: Decodable {
    let id: String
    let type: String
    let role: String
    let content: [ClaudeContent]
    let model: String
    let stop_reason: String?
    let usage: Usage?
}

struct ClaudeContent: Decodable {
    let type: String
    let text: String?
}

struct Usage: Decodable {
    let input_tokens: Int?
    let output_tokens: Int?
}

struct ClaudeResponse: Decodable {
    let content: [ClaudeContent]
}



