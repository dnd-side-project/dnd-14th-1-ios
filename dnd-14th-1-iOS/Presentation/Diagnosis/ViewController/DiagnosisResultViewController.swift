//
//  DiagnosisResultViewController.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/14/26.
//

import UIKit

import SnapKit
import Then

class DiagnosisResultViewController: BaseViewController {
    
    // MARK: - Properties
    
    weak var delegate: DiagnosisResultViewControllerDelegate?
    
    private let backgroundView = UIImageView()
    private let containerScrollView = UIScrollView()
    private let promptEfficiencyLabel = UILabel()
    private let promptStatusLabel = UILabel()
    private let meltedGlacierAmountLabel = UILabel()
    private let meltedGlacierUnitLabel = UILabel()
    private let tokenUsageScrollView = UIScrollView()
    private let tokenUsageStackView = UIStackView()
    private let glacierImageView = UIImageView()
    private let promptView = PromptView()
    private let buttonStackView = UIStackView()
    private let promptEditButton = AppButton(size: .large, title: "프롬프트 수정하기", image: UIImage(resource: .pencilSimpleLine))
    private let homeButton = UIButton()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setStyle() {
        let window = UIApplication.shared.keyWindow
        let bottomPadding = (window?.safeAreaInsets.bottom ?? 0) + 60
        
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
        
        glacierImageView.do {
            $0.image = UIImage(resource: .glacier3)
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
        
        promptEditButton.do {
            $0.addTarget(self, action: #selector(promptEditButtonTapped), for: .touchUpInside)
        }
    }
    
    override func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        containerScrollView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        promptEfficiencyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(containerScrollView.contentLayoutGuide).offset(20)
        }
        
        promptStatusLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(promptEfficiencyLabel.snp.bottom).offset(8)
        }
        
        meltedGlacierAmountLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(promptStatusLabel.snp.bottom).offset(8)
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
        
        glacierImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.top.equalTo(tokenUsageScrollView.snp.bottom).offset(22)
        }
        
        // contentLayoutGuide를 설정해야 ScrollView가 스크롤할 영역을 알수있음
        promptView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(glacierImageView.snp.bottom).offset(17)
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
            buttonStackView
        )
        
        // 토큰사용량 스택뷰에 서브뷰 추가
        
        tokenUsageStackView.addArrangedSubviews(
            TokenStatView(
                image: UIImage(resource: .tokenUsage),
                title: "현재 토큰 사용량",
                value: "142개"
            ),
            TokenStatView(
                image: UIImage(resource: .costUsage),
                title: "예상 손실 비용 ₩ / 회",
                value: "-₩150"
            ),
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
            glacierImageView,
            promptView
        )
    }
    
    @objc private func promptEditButtonTapped() {
        delegate?.promptEditButtonTapped()
    }
}
