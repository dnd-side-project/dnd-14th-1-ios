//
//  ErrorResponse.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/25/26.
//

import Foundation

struct ErrorResponse: Decodable, Error {
    let customStatusCode: Int
    let data: [String]?
    let message: String
    let status: Int
}
