//
//  EcoViewModel.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/27/26.
//

import Foundation
import Combine
import UIKit

final class EcoViewModel {
    
    enum Input {
        case viewDidLoad
    }
    enum Output {
        case updateEcoTier(EcoTier)
        case updateBadges([Badge])
        case showToast(message: String, type: UIViewController.ToastType)
    }
    
    // MARK: - Properties
    private let fetchEcoTierUseCase: FetchEcoTierUseCase
    private let fetchMyBadgesUseCase: FetchMyBadgesUseCase
    private let outputSubject = PassthroughSubject<Output, Never>()
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - Initializer
    init(
        fetchEcoTierUseCase: FetchEcoTierUseCase,
        fetchMyBadgesUseCase: FetchMyBadgesUseCase
    ) {
        self.fetchEcoTierUseCase = fetchEcoTierUseCase
        self.fetchMyBadgesUseCase = fetchMyBadgesUseCase
    }
    
    func transform(_ input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] input in
            guard let self else { return }
            switch input {
            case .viewDidLoad:
                fetchMyBadges()
                fetchEcoTier()
            }
        }.store(in: &subscriptions)
        
        return outputSubject.eraseToAnyPublisher()
    }
}

extension EcoViewModel {
    
    private func fetchEcoTier() {
        fetchEcoTierUseCase.execute().sink(
            receiveCompletion: { [weak self] comepltion in
                if case .failure(let error) = comepltion {
                    self?.outputSubject.send(.showToast(message: error.message, type: .internalError))
                }
            },
            receiveValue: { [weak self] ecoTier in
                self?.outputSubject.send(.updateEcoTier(ecoTier))
            }
        ).store(in: &subscriptions)
    }
    
    private func fetchMyBadges() {
        fetchMyBadgesUseCase.execute().sink(
            receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.outputSubject.send(.showToast(message: error.message, type: .internalError))
                }
            },
            receiveValue: { [weak self] badges in
                self?.outputSubject.send(.updateBadges(badges.data))
            }
        ).store(in: &subscriptions)
    }
}
