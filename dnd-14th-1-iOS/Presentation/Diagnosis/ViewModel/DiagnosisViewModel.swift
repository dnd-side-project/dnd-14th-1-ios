//
//  DiagnosisViewModel.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/15/26.
//

import Combine
import FoundationModels
import Foundation

final class DiagnosisViewModel: ViewModelType {
    // MARK: - State
    
    enum DiagnosisState {
        case loading
        case success
        case failure
    }
    
    // MARK: - Input
    
    enum Input {
        case viewDidAppear
        case viewDidLoad
        case promptButtonTapped
        case promptSheetDismissed
        case diagnosisButtonTapped(PromptInput)
    }
    
    // MARK: - Output
    
    enum Output {
        case presentPromptSheet
        case isPromptSheetPresented(Bool)
        case appleIntelligenceAuthorized(Bool)
        case diagnosisStateChanged(DiagnosisState)
    }
    
    // MARK: - Properties
    
    private let outputSubject = PassthroughSubject<Output, Never>()
    private let savedGlacierAmount = CurrentValueSubject<Double, Never>(0.0)
    private let isPromptSheetPresented = CurrentValueSubject<Bool, Never>(false)
    private let isAppleIntelligenceAvailable = CurrentValueSubject<Bool, Never>(false)
    
    private var subscriptions: Set<AnyCancellable> = []
    private var model = SystemLanguageModel.default
    
    init() {
        bind()
    }
    
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] input in
            guard let self else { return }
            switch input {
            case .viewDidAppear:
                checkAppleIntelligencePermission()
            case .viewDidLoad:
                fetchSavedGlacierAmount()
            case .promptButtonTapped:
                isPromptSheetPresented.send(true)
                outputSubject.send(.presentPromptSheet)
            case .promptSheetDismissed:
                isPromptSheetPresented.send(false)
            case let .diagnosisButtonTapped(promptInput):
                promptDiagnosis(with: promptInput)
            }
        }.store(in: &subscriptions)
        return outputSubject.eraseToAnyPublisher()
    }
    
    private func fetchSavedGlacierAmount() {
        self.savedGlacierAmount.send(0.0)
    }
    
    private func checkAppleIntelligencePermission() {
        switch model.availability {
        case .available:
            outputSubject.send(.appleIntelligenceAuthorized(true))
        default:
            outputSubject.send(.appleIntelligenceAuthorized(false))
        }
    }
    
    private func bind() {
        isPromptSheetPresented
            .map { Output.isPromptSheetPresented($0) }
            .subscribe(outputSubject)
            .store(in: &subscriptions)
    }
    
    private func promptDiagnosis(with promptInput: PromptInput) {
        outputSubject.send(.diagnosisStateChanged(.loading))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.outputSubject.send(.diagnosisStateChanged(.success))
        }
    }
}
