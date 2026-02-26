//
//  FetchMyBadgesUseCase.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/18/26.
//

import Foundation
import Combine

protocol FetchMyBadgesUseCase {
    func execute() -> AnyPublisher<MyBadges, ErrorResponse>
}

final class DefaultFetchMyBadgesUseCase: FetchMyBadgesUseCase {
    
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<MyBadges, ErrorResponse> {
        repository.fetchMyBadges()
    }
        
}
