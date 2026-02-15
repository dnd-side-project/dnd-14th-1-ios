//
//  DiagnosisViewController.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/11/26.
//

import UIKit

import SnapKit
import Then

final class DiagnosisViewController: BaseViewController {
    
    // MARK: - Properties
    private let promptTitle = UILabel()
    private let promptSubTitle = UILabel()
    private let savedGlacierAmountLabel = UILabel()
    private let savedGlacierAmount = UILabel()
    private let savedGlacierUnitLabel = UILabel()
    private let glacierImageView = UIImageView()
    private let promptButton = AppButton(style: .primary, size: .large, title: "프롬프트 진단받기", image: nil)
    
    weak var delegate: DiagnosisViewControllerDelegate?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
            promptButton
        )
    }
    
    override func setLayout() {
        promptButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        glacierImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(promptButton.snp.top).offset(-24)
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
    }
    
    override func setStyle() {
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
        
        glacierImageView.do {
            $0.image = UIImage(resource: .glacier5).resized(to: CGSize(width: 301, height: 342))
        }
        
        promptButton.do {
            $0.addTarget(self, action: #selector(promptButtonTapped), for: .touchUpInside)
        }
    }
}

// MARK: - objc function

extension DiagnosisViewController {
    @objc private func promptButtonTapped() {
        delegate?.didTapPromptButton()
    }
}
