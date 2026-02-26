//
//  CheckLoginUseCase.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/6/26.
//

import Foundation
import Combine

protocol CheckLoginUseCase {
    func execute() -> AnyPublisher<Bool, Never>
}

final class DefaultCheckLoginUseCase: CheckLoginUseCase {
    
    func execute() -> AnyPublisher<Bool, Never> {
        if let _ = KeychainWorker.shared.read(key: .access) {
            return Just(true)
                .eraseToAnyPublisher()
        } else {
            return Just(false)
                .eraseToAnyPublisher()
        }
    }
}
