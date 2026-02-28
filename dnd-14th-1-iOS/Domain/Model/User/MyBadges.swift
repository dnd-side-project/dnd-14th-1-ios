//
//  Badge.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/17/26.
//

import Foundation

struct MyBadges {
    let status: Int
    let data: [Badge]
    let message: String
}

struct Badge {
    let isCurrent: Bool
    let date: String
    let name: String
    let description: String
    let id: String
    let imageUrl: String
}
