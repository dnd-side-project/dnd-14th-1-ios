//
//  CheckLoginUseCase.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/6/26.
//

import Foundation
import Combine

protocol CheckLoginUseCase {
    func execute() -> AnyPublisher<Bool, Error>
}

final class MockCheckLoginUseCase: CheckLoginUseCase {
    
    func execute() -> AnyPublisher<Bool, Error> {
        return Just(false)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
