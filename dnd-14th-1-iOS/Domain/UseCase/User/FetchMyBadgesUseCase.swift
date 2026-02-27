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

final class MockFetchMyBadgesUseCase: FetchMyBadgesUseCase {
    
    func execute() -> AnyPublisher<MyBadges, ErrorResponse> {
        let myBadges = MyBadges(
            status: 0,
            data: [
                Badge(isCurrent: true, date: "", name: "", description: "", id: 0, imageUrl: "https://picsum.photos/id/237/200/300"),
                Badge(isCurrent: true, date: "", name: "", description: "", id: 0, imageUrl: "https://picsum.photos/id/237/200/300"),
                Badge(isCurrent: true, date: "", name: "", description: "", id: 0, imageUrl: "https://picsum.photos/id/237/200/300")
            ],
            message: "myBadges")
        
        return Just(myBadges)
            .setFailureType(to: ErrorResponse.self)
            .eraseToAnyPublisher()
    }
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
