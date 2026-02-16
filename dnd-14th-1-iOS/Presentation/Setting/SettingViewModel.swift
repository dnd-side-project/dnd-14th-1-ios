//
//  SettingViewModel.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/17/26.
//

import Foundation
import Combine

final class SettingViewModel: ViewModelType {
    enum Input {
        case viewDidLoad
    }
    
    enum Output {
        case updateUserProfile(UserProfile)
    }
    
    // MARK: - Properties
    private let fetchUserProfileUseCase: MockFetchUserProfileUseCase
    
    private let outputSubject = PassthroughSubject<Output, Never>()
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - Initializer
    init(fetchUserProfileUseCase: MockFetchUserProfileUseCase) {
        self.fetchUserProfileUseCase = fetchUserProfileUseCase
    }
    
    // MARK: - Transform
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] input in
            guard let self else { return }
            switch input {
            case .viewDidLoad:
                fetchUserProfile()
            }
        }.store(in: &subscriptions)
        
        return outputSubject.eraseToAnyPublisher()
    }
}

extension SettingViewModel {
    
    private func fetchUserProfile() {
        fetchUserProfileUseCase.execute().sink(
            receiveCompletion: { completion in
                if case .failure(let failure) = completion {
                    // TODO: 토스트 띄우기
                }
            },
            receiveValue: { [weak self] userProfile in
                self?.outputSubject.send(.updateUserProfile(userProfile))
            }
        ).store(in: &subscriptions)
    }
}
