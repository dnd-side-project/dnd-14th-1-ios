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
    var output_config: OutputConfig?
}

struct OutputConfig: Encodable {
    let format: OutputFormat
}

struct OutputFormat: Encodable {
    let type: String
    let schema: JSONSchema
}

struct JSONSchema: Encodable {
    let type: String
    let properties: [String: SchemaProperty]
    let required: [String]
    let additionalProperties: Bool
}

struct SchemaProperty: Encodable {
    let type: String
    let items: SchemaItems?
    
    init(type: String, items: SchemaItems? = nil) {
        self.type = type
        self.items = items
    }
}

struct SchemaItems: Encodable {
    let type: String
}

struct ClaudeMessage: Encodable {
    let role: String
    let content: String
}
