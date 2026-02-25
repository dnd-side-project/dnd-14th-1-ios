//
//  LoginViewModel.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/24/26.
//

import Foundation
import Combine
import UIKit

final class LoginViewModel {
    
    enum Input {
        case login(idToken: String)
    }
    enum Output {
        case showToast(message: String, type: UIViewController.ToastType)
        case loginCompleted
    }
    
    // MARK: - Properties
    private let loginUseCase: LoginUseCase
    private let outputSubject = PassthroughSubject<Output, Never>()
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - Initialzier
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    // MARK: - Transform
    func transform(_ input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] input in
            guard let self else { return }
            switch input {
            case let .login(idToken):
                login(idToken: idToken)
            }
        }.store(in: &subscriptions)
        
        return outputSubject.eraseToAnyPublisher()
    }
}

extension LoginViewModel {
    
    private func login(idToken: String) {
        loginUseCase.execute(idToken: idToken).sink(
            receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.outputSubject.send(.showToast(message: error.message, type: .internalError))
                }
            },
            receiveValue: { [weak self] result in
                let accessToken = result.data.accessToken
                let refreshToken = result.data.refreshToken
                let userID = result.data.userID
                KeychainWorker.shared.create(key: .access, value: accessToken)
                KeychainWorker.shared.create(key: .refresh, value: refreshToken)
                KeychainWorker.shared.create(key: .userId, value: userID)
                
                self?.outputSubject.send(.loginCompleted)
            }
        ).store(in: &subscriptions)
    }
}
