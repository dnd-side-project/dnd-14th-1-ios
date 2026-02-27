//
//  FetchEcoTierUseCase.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/27/26.
//

import Foundation
import Combine

protocol FetchEcoTierUseCase {
    func execute() -> AnyPublisher<EcoTier, ErrorResponse>
}

final class MockFetchEcoTierUseCase: FetchEcoTierUseCase {
    
    func execute() -> AnyPublisher<EcoTier, ErrorResponse> {
        let ecoTier = EcoTier(
            status: 200,
            data: EcoTierData(
                totalXP: 0,
                tier: 5,
                imageUrl: "https://picsum.photos/id/237/200/300",
                currentTierXP: 58,
                nextTierXP: 83
            ),
            message: "성공"
        )
        
        return Just(ecoTier)
            .setFailureType(to: ErrorResponse.self)
            .eraseToAnyPublisher()
    }
}
