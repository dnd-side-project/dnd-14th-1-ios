//
//  MyBadgesDto.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/25/26.
//

import Foundation

// MARK: - MyBadgesDto
struct MyBadgesDto: Decodable {
    let status: Int
    let data: [BadgeDto]
    let message: String
    
    func toDomain() -> MyBadges {
        return MyBadges(
            status: status,
            data: data.map { $0.toDomain() },
            message: message
        )
    }
}

// MARK: - Datum
struct BadgeDto: Decodable {
    let badgeID: String
    let name: String
    let description: String
    let tier: String
    let triggerType: String
    let triggerCondition: Int
    let enableImageURL: String
    let disableImageURL: String
    let earnedAt: String
    let isRepresentative: Bool

    enum CodingKeys: String, CodingKey {
        case badgeID = "badgeId"
        case name, description, tier, triggerType, triggerCondition
        case enableImageURL = "enableImageUrl"
        case disableImageURL = "disableImageUrl"
        case earnedAt, isRepresentative
    }
    
    func toDomain() -> Badge {
        return Badge(
            isCurrent: isRepresentative,
            date: earnedAt,
            name: name,
            description: description,
            id: badgeID,
            imageUrl: enableImageURL
        )
    }
}
