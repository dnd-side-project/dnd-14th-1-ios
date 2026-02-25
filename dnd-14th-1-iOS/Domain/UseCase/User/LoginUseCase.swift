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
    func exeucte(idToken: String) -> AnyPublisher<LoginResult, ErrorResponse>
}

final class DefaultLoginUseCase: LoginUseCase {
    
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func exeucte(idToken: String) -> AnyPublisher<LoginResult, ErrorResponse> {
        
        guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else {
            return Fail(error: ErrorResponse(customStatusCode: 000, data: [], message: "cannot get deviceId", status: 000))
                .eraseToAnyPublisher()
        }
        let platform = "IOS"
        let bundleIdentifier = "ac.dnd-14th-1-iOS"
        
        let requestModel = LoginRequest(
            deviceID: deviceId,
            platform: platform,
            packageName: bundleIdentifier,
            idToken: idToken
        )
        
        return repository.fetchLogin(requestModel: requestModel)
            .map { result in
                let accessToken = result.data.accessToken
                let refreshToken = result.data.refreshToken
                let userId = result.data.userID
                KeychainWorker.shared.create(key: .access, value: accessToken)
                KeychainWorker.shared.create(key: .refresh, value: refreshToken)
                KeychainWorker.shared.create(key: .userId, value: userId)
                return result
            }
            .eraseToAnyPublisher()
    }
}
