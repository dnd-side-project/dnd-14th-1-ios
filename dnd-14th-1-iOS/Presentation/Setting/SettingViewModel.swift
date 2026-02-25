//
//  SettingViewModel.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/17/26.
//

import Foundation
import Combine
import UIKit

final class SettingViewModel: ViewModelType {
    enum Input {
        case viewDidLoad
        case fetchBadgeList
        case handleLogout
        case changeRepresentativeBadge(Int)
    }
    
    enum Output {
        case updateUserProfile(UserProfile)
        case updateBadgeList([Badge])
        case showToast(message: String, type: UIViewController.ToastType)
    }
    
    // MARK: - Properties
    private let fetchUserProfileUseCase: FetchUserProfileUseCase
    private let fetchMyBadgesUseCase: FetchMyBadgesUseCase
    private let logoutUseCase: LogoutUseCase
    private let changeRepresentativeBadge: UpdateRepresentativeBadgeUseCase
    
    private let outputSubject = PassthroughSubject<Output, Never>()
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - Initializer
    init(fetchUserProfileUseCase: FetchUserProfileUseCase,
         fetchMyBadgesUseCase: FetchMyBadgesUseCase,
         logoutUseCase: LogoutUseCase,
         changeRepresentativeBadge: UpdateRepresentativeBadgeUseCase) {
        self.fetchUserProfileUseCase = fetchUserProfileUseCase
        self.fetchMyBadgesUseCase = fetchMyBadgesUseCase
        self.logoutUseCase = logoutUseCase
        self.changeRepresentativeBadge = changeRepresentativeBadge
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
            case .handleLogout:
                handleLogout()
            case .changeRepresentativeBadge(let selectedBadgeId):
                changeRepresentativeBadge(selectedBadgeId)
            }
        }.store(in: &subscriptions)
        
        return outputSubject.eraseToAnyPublisher()
    }
}

extension SettingViewModel {
    
    private func fetchUserProfile() {
        fetchUserProfileUseCase.execute().sink(
            receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.outputSubject.send(.showToast(message: error.message, type: .internalError))
                }
            },
            receiveValue: { [weak self] userProfile in
                self?.outputSubject.send(.updateUserProfile(userProfile))
            }
        ).store(in: &subscriptions)
    }
    
    private func fetchBadgeList() {
        fetchMyBadgesUseCase.execute().sink(
            receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.outputSubject.send(.showToast(message: error.message, type: .internalError))
                }
            },
            receiveValue: { [weak self] myBadges in
                self?.outputSubject.send(.updateBadgeList(myBadges.data))
            }
        ).store(in: &subscriptions)
    }
    
    private func handleLogout() {
        logoutUseCase.execute()
    }
    
    private func changeRepresentativeBadge(_ selectedBadgeId: Int) {
        changeRepresentativeBadge.execute(selectedBadgeId).sink(
            receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.outputSubject.send(.showToast(message: "대표 배지를 변경했습니다", type: .networkError)) // FIXME: 성공했을 때 정해진 피드백이 없어서 임시로 토스트를 띄움
                case .failure(let error):
                    self?.outputSubject.send(.showToast(message: error.message, type: .internalError))
                }
            },
            receiveValue: { _ in }
        ).store(in: &subscriptions)
    }
}
