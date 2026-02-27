//
//  EcoService.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/27/26.
//

import Foundation
import Combine

protocol EcoService {
    func fetchEcoTier() -> AnyPublisher<EcoTierDto, ErrorResponse>
}

final class DefaultEcoService: EcoService {
    
    private let networkService = NetworkService()
    
    func fetchEcoTier() -> AnyPublisher<EcoTierDto, ErrorResponse> {
        return networkService.request(api: EcoAPI.fetchEcoTier)
    }
}
