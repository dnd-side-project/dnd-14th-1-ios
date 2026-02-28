//
//  DefaultUserRepository.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/25/26.
//

import Foundation
import Combine

final class DefaultUserRepository: UserRepository {
    
    private let service: UserService
    
    init(service: UserService) {
        self.service = service
    }
    
    func fetchLogin(requestModel: LoginRequest) -> AnyPublisher<LoginResult, ErrorResponse> {
        service.fetchLogin(request: requestModel)
            .map { dto in
                return dto.toDomain()
            }
            .eraseToAnyPublisher()
    }
    
    func fetchUserProfile() -> AnyPublisher<UserProfile, ErrorResponse> {
        service.fetchUserProfile()
            .map { dto in
                return dto.toDomain()
            }
            .eraseToAnyPublisher()
    }
    
    func fetchMyBadges() -> AnyPublisher<MyBadges, ErrorResponse> {
        service.fetchMyBadges()
            .map { dto in
                return dto.toDomain()
            }
            .eraseToAnyPublisher()
    }
    
    func updateRepresentativeBadge(_ selectedBadgeId: String) -> AnyPublisher<Void, ErrorResponse> {
        let requestModel = UpdateRepresentativeBadgeRequest(badgeId: selectedBadgeId)
        
        return service.updateRepresentativeBadge(requestModel)
    }
}
