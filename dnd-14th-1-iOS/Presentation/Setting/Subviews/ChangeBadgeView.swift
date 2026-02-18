//
//  ChangeBadgeView.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/17/26.
//

import UIKit
import Combine
import SnapKit
import Then

final class ChangeBadgeView: UIView {
    
    // MARK: - Properties
    var onChangeBadgeButtonTapped: ((Int)->Void)?
    private var currentBadgeId: Int?
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - UI Components
    private let topIndicator = UIView()
    private let titleLabel = UILabel()
    private let changeBadgeCollectionView = ChangeBadgeCollectionView()
    private let changeBadgeButton = AppButton(size: .large, title: "변경하기", image: nil)
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
        addSubview()
        setLayout()
        setAddTarget()
        bind()
        backgroundColor = .white
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ badges: [Badge]) {
        if let currentBadgeId = badges.first(where: { $0.isCurrent })?.id {
            self.currentBadgeId = currentBadgeId
            changeBadgeButton.isEnabled = false
        }
        changeBadgeCollectionView.configure(badges: badges)
    }
}

extension ChangeBadgeView {
    
    private func bind() {
        changeBadgeCollectionView.didSelectBadgePublisher.sink { [weak self] in
            guard let self else { return }
            changeBadgeButton.isEnabled = changeBadgeCollectionView.selectedBadgeId != currentBadgeId
        }.store(in: &subscriptions)
    }
}

extension ChangeBadgeView {
    
    private func setAddTarget() {
        changeBadgeButton.addTarget(self, action: #selector(changeBadgeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func changeBadgeButtonTapped() {
        if let selectedBadgeId = changeBadgeCollectionView.selectedBadgeId {
            onChangeBadgeButtonTapped?(selectedBadgeId)
        }
    }
}

extension ChangeBadgeView {
    
    private func addSubview() {
        [topIndicator, titleLabel, changeBadgeCollectionView, changeBadgeButton].forEach {
            addSubview($0)
        }
    }
    
    private func setLayout() {
        topIndicator.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.height.equalTo(5)
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.leading.equalToSuperview().offset(28)
            $0.top.equalTo(topIndicator.snp.bottom).offset(24)
        }
        
        changeBadgeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(28)
            $0.bottom.equalToSuperview().offset(-40)
        }
        
        changeBadgeCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(28)
            $0.bottom.equalTo(changeBadgeButton.snp.top).offset(-16)
        }
    }
    
    private func setStyle() {
        topIndicator.do {
            $0.backgroundColor = UIColor.gray200
            $0.layer.cornerRadius = 2.5
        }
        
        titleLabel.do {
            $0.text = "대표 배지 변경"
            $0.font = UIFont.title1_b
            $0.textColor = UIColor.gray800
        }
    }
}
