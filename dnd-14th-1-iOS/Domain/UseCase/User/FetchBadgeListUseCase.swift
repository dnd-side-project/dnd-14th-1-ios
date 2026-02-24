//
//  FetchBadgeListUseCase.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/18/26.
//

import Foundation
import Combine

protocol FetchBadgeListUseCase {
    func execute() -> AnyPublisher<[Badge], Error>
}

final class MockFetchBadgeListUseCase: FetchBadgeListUseCase {
    
    func execute() -> AnyPublisher<[Badge], Error> {
        let mockBadgeList = [
            Badge(isCurrent: false, date: Date(), name: "배지1", description: "설명1", id: 1, imageUrl: "https://picsum.photos/id/237/200/300"),
            Badge(isCurrent: false, date: Date(), name: "배지2", description: "설명2", id: 2, imageUrl: "https://picsum.photos/id/237/200/300"),
            Badge(isCurrent: false, date: Date(), name: "배지3", description: "설명3", id: 3, imageUrl: "https://picsum.photos/id/237/200/300"),
            Badge(isCurrent: true, date: Date(), name: "배지4", description: "설명4", id: 4, imageUrl: "https://picsum.photos/id/237/200/300"),
            Badge(isCurrent: false, date: Date(), name: "배지5", description: "설명5", id: 5, imageUrl: "https://picsum.photos/id/237/200/300"),
            Badge(isCurrent: false, date: Date(), name: "배지6", description: "설명6", id: 6, imageUrl: "https://picsum.photos/id/237/200/300"),
            Badge(isCurrent: false, date: Date(), name: "배지7", description: "설명7", id: 7, imageUrl: "https://picsum.photos/id/237/200/300")
        ]
        
        let result = mockBadgeList.sorted(by: { $0.isCurrent && !$1.isCurrent })
        
        return Just(result)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
