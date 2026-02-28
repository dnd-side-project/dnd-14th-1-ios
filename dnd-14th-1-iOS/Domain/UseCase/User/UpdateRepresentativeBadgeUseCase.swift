//
//  UpdateRepresentativeBadgeUseCase.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/25/26.
//

import Foundation
import Combine

protocol UpdateRepresentativeBadgeUseCase {
    func execute(_ selectedBadgeId: String) -> AnyPublisher<Void, ErrorResponse>
}

final class DefaultUpdateRepresentativeBadgeUseCase: UpdateRepresentativeBadgeUseCase {
    
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func execute(_ selectedBadgeId: String) -> AnyPublisher<Void, ErrorResponse> {
        repository.updateRepresentativeBadge(selectedBadgeId)
    }
}
