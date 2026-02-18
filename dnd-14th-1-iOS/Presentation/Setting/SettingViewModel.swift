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
        case fetchBadgeList
    }
    
    enum Output {
        case updateUserProfile(UserProfile)
        case updateBadgeList([Badge])
    }
    
    // MARK: - Properties
    private let fetchUserProfileUseCase: FetchUserProfileUseCase
    private let fetchBadgeListUseCase: FetchBadgeListUseCase
    
    private let outputSubject = PassthroughSubject<Output, Never>()
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - Initializer
    init(fetchUserProfileUseCase: FetchUserProfileUseCase,
         fetchBadgeListUseCase: FetchBadgeListUseCase) {
        self.fetchUserProfileUseCase = fetchUserProfileUseCase
        self.fetchBadgeListUseCase = fetchBadgeListUseCase
    }
    
    // MARK: - Transform
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] input in
            guard let self else { return }
            switch input {
            case .viewDidLoad:
                fetchUserProfile()
            case .fetchBadgeList:
                fetchBadgeList()
            }
        }.store(in: &subscriptions)
        
        return outputSubject.eraseToAnyPublisher()
    }
}

extension SettingViewModel {
    
    private func fetchUserProfile() {
        fetchUserProfileUseCase.execute().sink(
            receiveCompletion: { _ in
                // TODO: 토스트 띄우기
            },
            receiveValue: { [weak self] userProfile in
                self?.outputSubject.send(.updateUserProfile(userProfile))
            }
        ).store(in: &subscriptions)
    }
    
    private func fetchBadgeList() {
        fetchBadgeListUseCase.execute().sink(
            receiveCompletion: { _ in
                // TODO: 토스트 띄우기
            },
            receiveValue: { [weak self] badges in
                self?.outputSubject.send(.updateBadgeList(badges))
            }
        ).store(in: &subscriptions)
    }
}
