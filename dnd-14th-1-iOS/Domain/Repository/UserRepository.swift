//
//  UserRepository.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/25/26.
//

import Foundation
import Combine

protocol UserRepository {
    func fetchLogin(requestModel: LoginRequest) -> AnyPublisher<LoginResult, ErrorResponse>
    func fetchUserProfile() -> AnyPublisher<UserProfile, ErrorResponse>
    func fetchMyBadges() -> AnyPublisher<MyBadges, ErrorResponse>
    func updateRepresentativeBadge(_ selectedBadgeId: String) -> AnyPublisher<Void, ErrorResponse>
}
