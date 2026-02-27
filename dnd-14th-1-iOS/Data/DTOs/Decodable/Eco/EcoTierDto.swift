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

// MARK: - DataClass
struct EcoTierDataDto: Decodable {
    let totalXP: Int
    let tier: Int
    let currentTierXP: Int
    let nextTierXP: Int

    enum CodingKeys: String, CodingKey {
        case totalXP = "totalXp"
        case tier
        case currentTierXP = "currentTierXp"
        case nextTierXP = "nextTierXp"
    }
    
    func toDomain() -> EcoTierData {
        return EcoTierData(
            totalXP: totalXP,
            tier: tier,
            imageUrl: "",
            description: "", // TODO: API 수정시 반영
            currentTierXP: currentTierXP,
            nextTierXP: nextTierXP
        )
    }
}
