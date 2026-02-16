//
//  UserProfile.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/17/26.
//

import Foundation

struct UserProfile {
    
    let imageUrl: String
    let nickname: String
    let domain: UserProfileDomain
    let email: String
}

enum UserProfileDomain {
    case google
    case apple
}
