//
//  DefaultEcoRepository.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/27/26.
//

import Foundation
import Combine

final class DefaultEcoRepository: EcoRepository {
    
    private let service: EcoService
    
    init(service: EcoService) {
        self.service = service
    }
    
    func fetchEcoTier() -> AnyPublisher<EcoTier, ErrorResponse> {
        return service.fetchEcoTier()
            .map { dto in
                dto.toDomain()
            }
            .eraseToAnyPublisher()
    }
}
