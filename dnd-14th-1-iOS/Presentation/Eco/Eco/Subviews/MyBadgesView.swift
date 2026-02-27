//
//  MyBadgesView.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/26/26.
//

import UIKit
import Combine
import Then
import SnapKit

final class MyBadgesView: UIView {
    
    // MARK: - Properties
    let didTapBadgePublisher = PassthroughSubject<Badge, Never>()
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - UI Components
    private let topIndicator = UIView()
    private let titleLabel = UILabel()
    private let countLabel = UILabel()
    private let myBadgesCollectionView = MyBagdesCollectionView()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubView()
        setLayout()
        setStyle()
        bind()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    func configure(badges: [Badge]) {
        updateCountLabel(numberOfBadges: badges.count)
        myBadgesCollectionView.configure(badges: badges)
    }
    
    // MARK: - Bind
    private func bind() {
        myBadgesCollectionView.didTapBadgePublisher.sink { [weak self] badge in
            self?.didTapBadgePublisher.send(badge)
        }.store(in: &subscriptions)
    }
    
    // MARK: - Base
    private func addSubView() {
        [topIndicator, titleLabel, countLabel, myBadgesCollectionView].forEach {
            addSubview($0)
        }
    }
    
    private func setLayout() {
        topIndicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(16)
            $0.width.equalTo(80)
            $0.height.equalTo(5)
        }
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(21)
            $0.top.equalTo(topIndicator.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(28)
        }
        
        countLabel.snp.makeConstraints {
            $0.height.equalTo(21)
            $0.top.equalTo(topIndicator.snp.bottom).offset(24)
            $0.trailing.equalToSuperview().offset(-28)
        }
        
        myBadgesCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(28)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setStyle() {
        backgroundColor = UIColor.commonWhite
        layer.cornerRadius = 54
        layer.cornerCurve = .continuous
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        topIndicator.do {
            $0.backgroundColor = UIColor.gray200
            $0.layer.cornerRadius = 2.5
        }
        
        titleLabel.do {
            $0.text = "나의 배지 보관함"
            $0.font = UIFont.title1_b
            $0.textColor = UIColor.gray800
        }
        
        myBadgesCollectionView.do {
            $0.backgroundColor = .clear
        }
    }
}

extension MyBadgesView {
    
    private func updateCountLabel(numberOfBadges: Int) {
        countLabel.do {
            let count = "\(numberOfBadges)" + "개"
            let description = "의 배지"
            let fullText = count + description
            
            let attributedString = NSMutableAttributedString(string: fullText)
            
            let countRange = (fullText as NSString).range(of: count)
            attributedString.addAttributes([
                .font : UIFont.title1_b,
                .foregroundColor : UIColor.gray900
            ], range: countRange)
            
            let descriptionRange = (fullText as NSString).range(of: description)
            attributedString.addAttributes([
                .font : UIFont.body2_m,
                .foregroundColor : UIColor.gray700
            ], range: descriptionRange)
            
            $0.attributedText = attributedString
        }
    }
}
