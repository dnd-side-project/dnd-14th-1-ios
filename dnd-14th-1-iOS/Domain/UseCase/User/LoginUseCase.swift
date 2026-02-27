//
//  LoginUseCase.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/24/26.
//

import Foundation
import Combine
import UIKit

protocol LoginUseCase {
    func execute(idToken: String) -> AnyPublisher<LoginResult, ErrorResponse>
}

final class MockLoginUseCase: LoginUseCase {
    
    func execute(idToken: String) -> AnyPublisher<LoginResult, ErrorResponse> {
        
        let loginResult = LoginResult(
            status: 200,
            data: LoginData(
                accessToken: "some accessToken",
                refreshToken: "some refreshToken",
                userID: "some userId"
            ),
            message: "MockLoginUseCase"
        )
        return Just(loginResult)
            .setFailureType(to: ErrorResponse.self)
            .eraseToAnyPublisher()
    }
}

final class DefaultLoginUseCase: LoginUseCase {
    
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func execute(idToken: String) -> AnyPublisher<LoginResult, ErrorResponse> {
        
        guard let deviceId = UIDevice.current.identifierForVendor?.uuidString,
              let bundleIdentifier = Bundle.main.bundleIdentifier else {
            return Fail(error: ErrorResponse(customStatusCode: 000, data: [], message: "cannot get deviceId", status: 000))
                .eraseToAnyPublisher()
        }
        let platform = "IOS"
        
        let requestModel = LoginRequest(
            deviceID: deviceId,
            platform: platform,
            packageName: bundleIdentifier,
            idToken: idToken
        )
        
        return repository.fetchLogin(requestModel: requestModel)
            .eraseToAnyPublisher()
    }
}
