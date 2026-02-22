//
//  FetchUserProfileUseCase.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/17/26.
//

import Foundation
import Combine

protocol FetchUserProfileUseCase {
    func execute() -> AnyPublisher<UserProfile, Error>
}

final class MockFetchUserProfileUseCase: FetchUserProfileUseCase {
    
    func execute() -> AnyPublisher<UserProfile, Error> {
        let mockUserProfile = UserProfile(
            imageUrl: "https://picsum.photos/id/237/200/300",
            nickname: "사용자",
            domain: .apple,
            email: "user@example.com"
        )
        return Just(mockUserProfile)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
