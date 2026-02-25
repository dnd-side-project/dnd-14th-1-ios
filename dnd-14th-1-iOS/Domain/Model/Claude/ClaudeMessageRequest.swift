//
//  ClaudeMessageRequest.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/25/26.
//

import Foundation

struct ClaudeMessageRequest: Encodable {
    let model: String
    let max_tokens: Int
    let messages: [ClaudeMessage]
}

struct ClaudeMessage: Encodable {
    let role: String
    let content: String
}
