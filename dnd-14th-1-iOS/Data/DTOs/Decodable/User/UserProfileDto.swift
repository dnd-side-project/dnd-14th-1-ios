//
//  UserProfileDto.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/25/26.
//

import Foundation

struct UserProfileDto: Decodable {
    let status: Int
    let data: UserProfileDataDto
    let message: String
    
    func toDomain() -> UserProfile {
        return UserProfile(
            imageUrl: data.representativeBadge?.enableImageURL ?? "",
            nickname: data.name ?? "익명",
            domain: .apple,
            email: data.email)
    }
}

struct UserProfileDataDto: Decodable {
    let userID: String
    let email: String
    let name: String?
    let createdAt: String
    let representativeBadge: RepresentativeBadgeDto?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case email, name, createdAt, representativeBadge
    }
}

struct RepresentativeBadgeDto: Decodable {
    let badgeID: String
    let name: String
    let tier: String
    let enableImageURL: String
    let disableImageURL: String

    enum CodingKeys: String, CodingKey {
        case badgeID = "badgeId"
        case name, tier
        case enableImageURL = "enableImageUrl"
        case disableImageURL = "disableImageUrl"
    }
}
