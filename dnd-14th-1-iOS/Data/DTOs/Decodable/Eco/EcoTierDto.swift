//
//  EcoTierDto.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/27/26.
//

import Foundation

struct EcoTierDto: Decodable {
    let status: Int
    let data: EcoTierDataDto
    let message: String
    
    func toDomain() -> EcoTier {
        return EcoTier(
            status: status,
            data: data.toDomain(),
            message: message
        )
    }
}

struct EcoTierDataDto: Decodable {
    let totalXP, tier, currentTierXP, nextTierXP: Int
    let badgeProgress: [BadgeProgressDto]

    enum CodingKeys: String, CodingKey {
        case totalXP = "totalXp"
        case tier
        case currentTierXP = "currentTierXp"
        case nextTierXP = "nextTierXp"
        case badgeProgress
    }
    
    func toDomain() -> EcoTierData {
        let badge = badgeProgress.first(where: { $0.currentBadgeEnableImageURL != nil && $0.currentBadgeDescription != nil })
        
        return EcoTierData(
            totalXP: totalXP,
            tier: tier,
            imageUrl: badge?.currentBadgeEnableImageURL ?? "",
            description: badge?.currentBadgeDescription ?? "",
            currentTierXP: currentTierXP,
            nextTierXP: nextTierXP
        )
    }
}

struct BadgeProgressDto: Decodable {
    let triggerType: String?
    let currentValue: Int?
    let currentBadgeTier: String?
    let currentBadgeDescription: String?
    let currentBadgeEnableImageURL: String?
    let nextBadgeTriggerCondition: Int?
    let nextBadgeTier: String?
    let nextBadgeDescription: String?
    let nextBadgeEnableImageURL: String?

    enum CodingKeys: String, CodingKey {
        case triggerType, currentValue, currentBadgeTier, currentBadgeDescription
        case currentBadgeEnableImageURL = "currentBadgeEnableImageUrl"
        case nextBadgeTriggerCondition, nextBadgeTier, nextBadgeDescription
        case nextBadgeEnableImageURL = "nextBadgeEnableImageUrl"
    }
}
