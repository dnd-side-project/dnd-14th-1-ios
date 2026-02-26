//
//  FetchUserProfileUseCase.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/17/26.
//

import Foundation
import Combine

protocol FetchUserProfileUseCase {
    func execute() -> AnyPublisher<UserProfile, ErrorResponse>
}

final class DefaultFetchUserProfileUseCase: FetchUserProfileUseCase {
    
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<UserProfile, ErrorResponse> {
        return repository.fetchUserProfile()
    }
}
