//
//  DiagnosisViewController.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/11/26.
//

import UIKit
import Combine

import SnapKit
import Then

final class DiagnosisViewController: BaseViewController {
    
    // MARK: - Properties
    
    // UI
    private let promptTitle = UILabel()
    private let promptSubTitle = UILabel()
    private let savedGlacierAmountLabel = UILabel()
    private let savedGlacierAmount = UILabel()
    private let savedGlacierUnitLabel = UILabel()
    private let glacierImageView = UIImageView()
    private let promptButton = AppButton(style: .primary, size: .large, title: "프롬프트 진단받기", image: nil)
    private let appleIntelligenceButton = UIButton()
    private let errorLabel = UILabel()
    
    private let viewModel: DiagnosisViewModel
    private let inputSubject = PassthroughSubject<DiagnosisViewModel.Input, Never>()
    
    private var subscriptions: Set<AnyCancellable> = []
    
    weak var delegate: DiagnosisViewControllerDelegate?
    
    init(viewModel: DiagnosisViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        addTargets()
        dismissKeyboardWhenTapAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputSubject.send(.viewDidAppear)
    }
    
    private func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        
        outputSubject.receive(on: DispatchQueue.main).sink { [weak self] output in
            guard let self else { return }
            switch output {
            case .presentPromptSheet:
                showPromptSheet()
            case let .isPromptSheetPresented(isPresented):
                updatePromptTitle(isPresented)
            case let .appleIntelligenceAuthorized(isGranted):
                checkAppleIntelligence(isGranted)
            }
        }.store(in: &subscriptions)
    }
    
    private func showPromptSheet() {
        let sheetHeight = UIScreen.main.bounds.height - promptSubTitle.frame.minY
        let bottomSheetPresenter = BottomSheetPresenter()
        let promptInputView = PromptInputView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: sheetHeight))
        
        promptInputView.buttonTapped = { [weak self] text in
            self?.delegate?.didTapPromptButton()
        }
        
        bottomSheetPresenter.onDissmiss = {
            self.inputSubject.send(.promptSheetDismissed)
        }

        bottomSheetPresenter.present(
            on: self,
            contentView: promptInputView,
            height: sheetHeight
        )
    }
    
    // MARK: - Set Layout
    
    override func addSubview() {
        view.addSubviews(
            promptTitle,
            promptSubTitle,
            savedGlacierAmountLabel,
            savedGlacierAmount,
            savedGlacierUnitLabel,
            glacierImageView,
            promptButton,
            appleIntelligenceButton,
            errorLabel
        )
    }
    
    override func setLayout() {
        promptButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        appleIntelligenceButton.snp.makeConstraints {
            $0.edges.equalTo(promptButton)
        }
        
        glacierImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(promptButton.snp.top).offset(-40)
        }
        
        promptTitle.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.leading.equalToSuperview().offset(20)
        }
        
        promptSubTitle.snp.makeConstraints {
            $0.leading.equalTo(promptTitle.snp.leading)
            $0.top.equalTo(promptTitle.snp.bottom).offset(8)
        }
        
        savedGlacierAmountLabel.snp.makeConstraints {
            $0.top.equalTo(promptSubTitle).offset(41)
            $0.leading.equalTo(promptTitle.snp.leading)
        }
        
        savedGlacierUnitLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalTo(savedGlacierAmountLabel.snp.centerY)
        }
        
        savedGlacierAmount.snp.makeConstraints {
            $0.trailing.equalTo(savedGlacierUnitLabel.snp.leading).offset(-4)
            $0.centerY.equalTo(savedGlacierAmountLabel.snp.centerY)
        }
        
        errorLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(appleIntelligenceButton.snp.top).offset(-8)
        }
    }
    
    override func setStyle() {
        view.backgroundColor = .white
        
        promptTitle.do {
            $0.text = "지금 프롬프트를 진단하고\n최적화된 한 줄을 만들어요"
            $0.numberOfLines = 2
            $0.font = .headline2_b
            $0.textColor = .gray800
        }
        
        promptSubTitle.do {
            $0.text = "숨은 토큰 낭비를 찾아 북극곰의 집을 지켜주세요!"
            $0.font = .body2_b
            $0.textColor = .gray500
        }
        
        savedGlacierAmountLabel.do {
            $0.text = "내가 지킨 빙하량"
            $0.font = .title1_b
            $0.textColor = .gray700
        }
        
        savedGlacierAmount.do {
            $0.text = "0.0"
            $0.font = .hakgyoansimDunggeunmisoBold
            $0.textColor = .primary500
        }
        
        savedGlacierUnitLabel.do {
            $0.text = "kg"
            $0.font = .hakgyoansimDunggeunmisoRegular
            $0.textColor = .gray700
        }
        
        promptButton.do {
            $0.isHidden = true
        }
        
        appleIntelligenceButton.do {
            $0.isHidden = true
            $0.setImage(UIImage(resource: .appleIntelligenceButton), for: .normal)
        }
        
        errorLabel.do {
            $0.isHidden = true
            $0.text = "Apple Intelligence가 비활성화로 서비스 이용이 불가합니다"
            $0.font = .label2_m
            $0.textColor = .negative
        }
    }
    
    private func addTargets() {
        promptButton.addTarget(self, action: #selector(promptButtonTapped), for: .touchUpInside)
        appleIntelligenceButton.addTarget(self, action: #selector(intelligenceButtonTapped), for: .touchUpInside)
    }
}

// MARK: - objc function

extension DiagnosisViewController {
    @objc private func promptButtonTapped() {
        inputSubject.send(.promptButtonTapped)
    }
    
    @objc private func intelligenceButtonTapped() {
        let settingAppleIntelligenceView = SettingAppleIntelligenceView()
        let bottomSheetViewController = UIViewController()
        bottomSheetViewController.view = settingAppleIntelligenceView
        
        settingAppleIntelligenceView.onDismiss = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        settingAppleIntelligenceView.onSetting = { [weak self] in
            self?.openAppSetting()
        }
        
        if let sheet = bottomSheetViewController.sheetPresentationController {
            sheet.detents = [.custom { _ in 470 }]
            sheet.preferredCornerRadius = 56
        }
        
        present(bottomSheetViewController, animated: true)
    }
}

// MARK: - Update View

extension DiagnosisViewController {
    private func updatePromptTitle(_ isPresented: Bool) {
        UIView.transition(
            with: promptTitle,
            duration: 0.25,
            options: .transitionCrossDissolve,
            animations: {
                self.promptTitle.text = isPresented
                ? "프롬프트 내용을 입력하시면\n진단을 도와드릴게요!"
                : "지금 프롬프트를 진단하고\n최적화된 한 줄을 만들어요"
            }
        )
    }
    
    private func checkAppleIntelligence(_ isGranted: Bool) {
        glacierImageView.image = isGranted ? .glacier5 : .glacierUnavailable
        if isGranted {
            promptButton.isHidden = false
            appleIntelligenceButton.isHidden = true
            errorLabel.isHidden = true
        } else {
            promptButton.isHidden = true
            appleIntelligenceButton.isHidden = false
            errorLabel.isHidden = false
        }
    }
}

// MARK: - Hepler

extension DiagnosisViewController {
    func openAppSetting() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                
            })
        }
    }
}
