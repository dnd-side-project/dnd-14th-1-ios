//
//  EcoTier.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/27/26.
//

import Foundation

struct EcoTier {
    let status: Int
    let data: EcoTierData
    let message: String
}

struct EcoTierData {
    let totalXP: Int
    let tier: Int
    let imageUrl: String
    let currentTierXP: Int
    let nextTierXP: Int
}
