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
        case success(PromptDiagnosisResult)
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
        case displayGlacierGrade(GlacierGrade)
        case errorOccurred(String)
    }
    
    // MARK: - Properties
    
    private let outputSubject = PassthroughSubject<Output, Never>()
    private let savedGlacierAmount = CurrentValueSubject<Double, Never>(0.0)
    private let isPromptSheetPresented = CurrentValueSubject<Bool, Never>(false)
    private let isAppleIntelligenceAvailable = CurrentValueSubject<Bool, Never>(false)
    
    private var subscriptions: Set<AnyCancellable> = []
    private var model = SystemLanguageModel.default
    
    private let promptDiagnosisUseCase: PromptDiagnosisUseCase
    private let conversationParsingUseCase: ConversationParsingUseCase
    private let fetchEcoTierUseCsse: FetchEcoTierUseCase
    
    init(
        promptDiagnosisUseCase: PromptDiagnosisUseCase,
        conversationParsingUseCase: ConversationParsingUseCase,
        fetchEcoTierUseCsse: FetchEcoTierUseCase
    ) {
        self.promptDiagnosisUseCase = promptDiagnosisUseCase
        self.conversationParsingUseCase = conversationParsingUseCase
        self.fetchEcoTierUseCsse = fetchEcoTierUseCsse
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
                switch promptInput.type {
                case .text:
                    promptDiagnosis(with: promptInput)
                case .url:
                    promptDiagnosisWithUrl(with: promptInput)
                }
                
            }
        }.store(in: &subscriptions)
        return outputSubject.eraseToAnyPublisher()
    }
    
    private func fetchEcoTier() {
        fetchEcoTierUseCsse.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    self?.outputSubject.send(.errorOccurred(error.localizedDescription))
                }
            } receiveValue: {  [weak self] ecoTier in
                self?.outputSubject.send(.displayGlacierGrade(GlacierGrade(grade: ecoTier.data.tier)))
            }
            .store(in: &subscriptions)
    }
    
    private func fetchSavedGlacierAmount() {
        self.savedGlacierAmount.send(0.0)
    }
    
    // Apple Intelligence 가용성 체크 후 ecoTier 업데이트
    private func checkAppleIntelligencePermission() {
        switch model.availability {
        case .available:
            outputSubject.send(.appleIntelligenceAuthorized(true))
            fetchEcoTier()
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
        
        Task {
            do {
                let diagnosisResult = try await promptDiagnosisUseCase.excute(prompt: promptInput.value)
                outputSubject.send(.diagnosisStateChanged(.success(diagnosisResult)))
            } catch {
                outputSubject.send(.diagnosisStateChanged(.failure))
            }
        }
    }
    
    private func promptDiagnosisWithUrl(with promptInput: PromptInput) {
        outputSubject.send(.diagnosisStateChanged(.loading))
        
        Task {
            do {
                let diagnosisResult = try await conversationParsingUseCase.execute(promptInput: promptInput)
                outputSubject.send(.diagnosisStateChanged(.success(diagnosisResult)))
            } catch {
                outputSubject.send(.diagnosisStateChanged(.failure))
            }
        }
    }
}
