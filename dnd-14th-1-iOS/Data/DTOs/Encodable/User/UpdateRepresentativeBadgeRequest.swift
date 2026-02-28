//
//  UpdateRepresentativeBadgeRequest.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/25/26.
//

import Foundation

struct UpdateRepresentativeBadgeRequest: Encodable {
    let badgeId: String

    enum CodingKeys: String, CodingKey {
        case badgeId = "badgeId"
    }
}
