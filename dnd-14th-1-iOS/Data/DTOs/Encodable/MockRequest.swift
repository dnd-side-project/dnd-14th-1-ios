//
//  MockRequest.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 1/31/26.
//

import Foundation

struct MockRequest: Encodable {
    let name: String
    let userAddress: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case userAddress = "user_address"
    }
}
