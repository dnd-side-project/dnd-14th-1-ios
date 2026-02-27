//
//  EcoRepository.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/27/26.
//

import Foundation
import Combine

protocol EcoRepository {
    func fetchEcoTier() -> AnyPublisher<EcoTier, ErrorResponse>
}
