//
//  DefaultUserRepositoru.swift
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
                dto.toDomain()
            }
            .eraseToAnyPublisher()
    }
}
