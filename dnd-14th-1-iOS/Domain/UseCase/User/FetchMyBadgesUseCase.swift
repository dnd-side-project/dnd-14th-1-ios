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
                Badge(isCurrent: true, date: "2022-02-02", name: "빙하 가디언", description: "서비스 가입 후 첫 번째\n프롬프트 교정 및 전송 완료", id: "", imageUrl: "https://picsum.photos/id/237/200/300"),
                Badge(isCurrent: true, date: "2022-02-02", name: "빙하 가디언", description: "서비스 가입 후 첫 번째\n프롬프트 교정 및 전송 완료", id: "", imageUrl: "https://picsum.photos/id/237/200/300"),
                Badge(isCurrent: true, date: "2022-02-02", name: "빙하 가디언", description: "서비스 가입 후 첫 번째\n프롬프트 교정 및 전송 완료", id: "", imageUrl: "https://picsum.photos/id/237/200/300")
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
