//
//  DiagnosisResultViewController.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/14/26.
//

import UIKit
import Combine

import SnapKit
import Then
import Lottie

class DiagnosisResultViewController: BaseViewController {
    
    // MARK: - Properties
    
    var viewModel: DiagnosisResultViewModel
    
    weak var delegate: DiagnosisResultViewControllerDelegate?
    
    private var subscriptions: Set<AnyCancellable> = []
    
    private let inputSubject = PassthroughSubject<DiagnosisResultViewModel.Input, Never>()
    private let backgroundView = UIImageView()
    private let containerScrollView = UIScrollView()
    private let promptEfficiencyLabel = UILabel()
    private let promptStatusLabel = UILabel()
    private let meltedGlacierAmountLabel = UILabel()
    private let meltedGlacierUnitLabel = UILabel()
    private let tokenUsageScrollView = UIScrollView()
    private let tokenUsageStackView = UIStackView()
    private let glacierView = LottieAnimationView(name: "glacier5")
    private let promptView = PromptView()
    private let buttonStackView = UIStackView()
    private let promptEditButton = AppButton(size: .large, title: "프롬프트 수정하기", image: UIImage(resource: .pencilSimpleLine))
    private let completeDiagnosisButton = AppButton(size: .large, title: "진단 마치기", image: UIImage(resource: .check))
    private let homeButton = UIButton()
    private let inputTokenStatView = TokenStatView()
    private let outputTokenStatView = TokenStatView()
    private let costStatView = TokenStatView()
    private let usingModelLabel = UILabel()
    
    init(viewModel: DiagnosisResultViewModel) {
        self.viewModel = viewModel
        super.init()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        inputSubject.send(.viewDidLoad)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        glacierView.play()
    }
    
    private func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        
        outputSubject.receive(on: DispatchQueue.main).sink { [weak self] output in
            switch output {
            case let .displayDiagnosisResult(promptDiagnosis):
                self?.displayPromptDiagnosis(promptDiagnosis)
            case let .promptImproveStateChanged(state):
                switch state {
                case .loading:
                    self?.delegate?.startPromptImprovement()
                case let .success(prompt, result):
                    self?.delegate?.completePromptImprovement(promt: prompt, result: result)
                case .failure:
                    self?.delegate?.failPromptImprovement()
                }
            }
        }
        .store(in: &subscriptions)
    }
    
    private func displayPromptDiagnosis(_ promptDiagnosis: PromptDiagnosisResult) {
        let isEfficiency = promptDiagnosis.efficiency == .efficiency
        backgroundView.image = isEfficiency ? .diagnosisResultBgSuccess : .diagnosisResultBgWarning
        promptEfficiencyLabel.text = isEfficiency ? "효율적인 프롬프트예요!" : "비효율적인 프롬프트예요!"
        meltedGlacierAmountLabel.text = String(format: "-%.2f", promptDiagnosis.meltedGlacierAmount)
        inputTokenStatView.value = "\(promptDiagnosis.inputToken)개"
        outputTokenStatView.value = "\(promptDiagnosis.outputToken)개"
        costStatView.value = String(format: "- ₩%.2f", promptDiagnosis.estimatedLoss)
        promptView.content = promptDiagnosis.originalPrompt
        meltedGlacierAmountLabel.textColor = isEfficiency ? .positiveDarkbg : .negativeDarkbg
        meltedGlacierUnitLabel.textColor = isEfficiency ? .positiveDarkbg : .negativeDarkbg
        usingModelLabel.text = "\(promptDiagnosis.usingModel.modelName) 모델을 사용한 결과예요"
        setButtonState(promptDiagnosis.source)
    }
    
    private func setButtonState(_ source: PromptSource) {
        switch source {
        case .singlePrompt:
            completeDiagnosisButton.isHidden = true
        case .url:
            buttonStackView.isHidden = true
        }
    }
    
    override func setStyle() {
        let window = UIApplication.shared.keyWindow
        let bottomPadding = (window?.safeAreaInsets.bottom ?? 0) + 60
        
        usingModelLabel.do {
            $0.font = .label2_m
            $0.textColor = UIColor.init(hexCode: "#D4D4D4")
        }
                
        inputTokenStatView.do {
            $0.title = "인풋 토큰 사용량"
            $0.icon = .tokenUsage
        }
        
        outputTokenStatView.do {
            $0.title = "아웃풋 토큰 사용량"
            $0.icon = .tokenUsage
        }
        
        costStatView.do {
            $0.title = "예상 발생 금액 ₩ / 회"
            $0.icon = .costUsage
        }
        
        containerScrollView.do {
            $0.showsVerticalScrollIndicator = false
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomPadding, right: 0)
        }
        
        backgroundView.do {
            $0.image = UIImage(resource: .diagnosisResultBgWarning)
        }
        
        promptEfficiencyLabel.do {
            $0.font = .headline3_b
            $0.textColor = .white
            $0.text = "비효율적인 프롬프트예요!"
        }
        
        promptStatusLabel.do {
            $0.font = .body1_b
            $0.textColor = .white
            $0.text = "녹아내린 빙하량"
        }
        
        meltedGlacierAmountLabel.do {
            $0.font = .hakgyoansimDunggeunmisoBold_32
            $0.textColor = .negativeDarkbg
            $0.text = "-0.75"
        }
        
        tokenUsageScrollView.do {
            $0.alwaysBounceHorizontal = true
            $0.alwaysBounceVertical = false
            $0.showsHorizontalScrollIndicator = false
            $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        
        tokenUsageStackView.do {
            $0.spacing = 16
            $0.axis = .horizontal
        }
        
        meltedGlacierUnitLabel.do {
            $0.font = .hakgyoansimDunggeunmisoRegular_24
            $0.textColor = .negativeDarkbg
            $0.text = "kg"
        }
        
        buttonStackView.do {
            $0.spacing = 12
        }
        
        homeButton.do {
            $0.setImage(UIImage(resource: .homeButton), for: .normal)
        }
    }
    
    private func addTargets() {
        homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        promptEditButton.addTarget(self, action: #selector(promptEditButtonTapped), for: .touchUpInside)
        completeDiagnosisButton.addTarget(self, action: #selector(completeDiagnosisButtonTapped), for: .touchUpInside)
    }
    
    override func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        containerScrollView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view)
        }
        
        promptEfficiencyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(containerScrollView.contentLayoutGuide).offset(20)
            $0.height.equalTo(31)
        }
        
        promptStatusLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(promptEfficiencyLabel.snp.bottom).offset(8)
            $0.height.equalTo(24)
        }
        
        meltedGlacierAmountLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(promptStatusLabel.snp.bottom).offset(8)
            $0.height.equalTo(32)
        }
        
        tokenUsageScrollView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(meltedGlacierAmountLabel.snp.bottom).offset(28)
            $0.height.equalTo(92)
        }
        
        tokenUsageStackView.snp.makeConstraints {
            $0.edges.equalTo(tokenUsageScrollView.contentLayoutGuide)
            $0.height.equalTo(tokenUsageScrollView)
        }
        
        usingModelLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(tokenUsageScrollView.snp.bottom).offset(12)
            $0.height.equalTo(12)
        }
        
        glacierView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(usingModelLabel.snp.bottom).offset(22)
        }
        
        // contentLayoutGuide를 설정해야 ScrollView가 스크롤할 영역을 알수있음
        promptView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(glacierView.snp.bottom).offset(17)
            $0.bottom.equalTo(containerScrollView.contentLayoutGuide)
            $0.width.equalTo(containerScrollView.frameLayoutGuide).offset(-40)
        }
        
        meltedGlacierUnitLabel.snp.makeConstraints {
            $0.centerY.equalTo(meltedGlacierAmountLabel)
            $0.leading.equalTo(meltedGlacierAmountLabel.snp.trailing).offset(4)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-5)
        }
        
        completeDiagnosisButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-5)
        }
        
        homeButton.snp.makeConstraints {
            $0.width.equalTo(68)
            $0.height.equalTo(60)
        }
    }
    
    override func addSubview() {
        // view에 subview 추가
        view.addSubviews(
            backgroundView,
            containerScrollView,
            buttonStackView,
            completeDiagnosisButton
        )
        
        // 토큰사용량 스택뷰에 서브뷰 추가
        
        tokenUsageStackView.addArrangedSubviews(
            inputTokenStatView,
            outputTokenStatView,
            costStatView
        )
        
        // 토큰사용량 스크롤뷰에 스택뷰 추가
        tokenUsageScrollView.addSubviews(
            tokenUsageStackView
        )
        
        buttonStackView.addArrangedSubviews(
            promptEditButton,
            homeButton
        )
        
        // 컨테이너뷰에 최종 뷰 추가
        containerScrollView.addSubviews(
            promptEfficiencyLabel,
            promptStatusLabel,
            meltedGlacierAmountLabel,
            meltedGlacierUnitLabel,
            tokenUsageScrollView,
            glacierView,
            promptView,
            usingModelLabel
        )
    }
    
    @objc private func promptEditButtonTapped() {
        inputSubject.send(.promptImproveButtonTapped)
    }
    
    @objc private func completeDiagnosisButtonTapped() {
        delegate?.completeButtonTapped()
    }
    
    @objc private func homeButtonTapped() {
        delegate?.homeButtonTapped()
    }
}
