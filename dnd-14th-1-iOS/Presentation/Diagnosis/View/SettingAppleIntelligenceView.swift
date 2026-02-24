//
//  SettingAppleIntelligenceView.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/24/26.
//

import UIKit

import SnapKit
import Then

final class SettingAppleIntelligenceView: UIView {
    
    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    private let descriptionView = UIView()
    private let descriptionLabel = UILabel()
    private let settingButton = AppButton(size: .large, title: "활성화하기", image: nil)
    private let dismissButton = UIButton()
    
    var onDismiss: (() -> Void)?
    var onSetting: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubView()
        setStyle()
        setLayout()
        addTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubView() {
        descriptionView.addSubview(
            descriptionLabel
        )
        
        addSubviews(
            titleLabel,
            imageView,
            descriptionView,
            settingButton,
            dismissButton
        )
    }
    
    private func setStyle() {
        titleLabel.do {
            $0.font = .headline3_b
            $0.textColor = .gray900
            $0.numberOfLines = 2
            $0.text = "정상적인 서비스의 작동을 위해\n기능을 활성화해주세요!"
        }
        
        imageView.do {
            $0.image = UIImage(resource: .settingAppleIntelligence)
        }
        
        descriptionView.do {
            $0.layer.borderColor = UIColor.gray200.cgColor
            $0.layer.borderWidth = 2
            $0.layer.cornerRadius = 16
        }
        
        descriptionLabel.do {
            $0.text = "설정-Apple Intelligence 활성화를 통해\nSAVING 서비스를 이용할 수 있어요."
            $0.font = .body2_r
            $0.numberOfLines = 0
            $0.textColor = .gray800
            $0.asFont(targetString: "설정-Apple Intelligence 활성화", font: .body2_b)
        }
        
        dismissButton.do {
            $0.setImage(UIImage(resource: .xMark), for: .normal)
        }
    }
    
    private func setLayout() {
        dismissButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(dismissButton.snp.bottom)
            $0.leading.equalToSuperview().offset(24)
        }
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
        }
        
        descriptionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.top.equalTo(imageView.snp.bottom).offset(8)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().offset(20)
        }
        
        settingButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.top.equalTo(descriptionView.snp.bottom).offset(24)
        }
    }
    
    private func addTargets() {
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        settingButton.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
    }
    
    @objc private func settingButtonTapped() {
        onSetting?()        
    }
    
    @objc private func dismissButtonTapped() {
        onDismiss?()
    }
}
