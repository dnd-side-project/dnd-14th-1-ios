//
//  ShareBadgeModalViewController.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/27/26.
//

import UIKit
import Combine
import SnapKit
import Then

final class ShareBadgeModalViewController: BaseViewController {
    
    // MARK: - Properties
    private let kakaoShareUseCase: KakaoShareUseCase
    private var subscriptions: Set<AnyCancellable> = []
    private let badge: Badge
    private var didLayoutSubviews = false
    
    
    // MARK: - UI Components
    private let blurredBackgroundView = CustomVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark), intensity: 0.2)
    private let contentView = UIView()
    private let closeButton = UIButton()
    private let shareButton = AppButton(size: .large, title: "SNS 공유", image: UIImage.shareNetwork)
    
    private let wrapperView = UIView()
    private let myBadgeLabel = UILabel()
    private let dateLabel = UILabel()
    private let badgeImageView = UIImageView()
    private let badgeTitleLabel = UILabel()
    private let badgeDescriptionLabel = UILabel()
    
    // MARK: - Initializer
    init(
        badge: Badge,
        kakaoShareUseCase: KakaoShareUseCase
    ) {
        self.badge = badge
        self.kakaoShareUseCase = kakaoShareUseCase
        super.init()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setAddTarget()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !didLayoutSubviews {
            setUpGradientBackground()
            didLayoutSubviews = true
        }
    }
    
    // MARK: - Base
    
    override func addSubview() {
        [myBadgeLabel, dateLabel, badgeImageView, badgeTitleLabel, badgeDescriptionLabel].forEach {
            wrapperView.addSubview($0)
        }
        [wrapperView, closeButton, shareButton].forEach {
            contentView.addSubview($0)
        }
        [blurredBackgroundView, contentView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        view.backgroundColor = .clear
        
        blurredBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        closeButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.top.trailing.equalTo(contentView).inset(28)
        }
        
        wrapperView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(contentView)
        }
        
        myBadgeLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.top.equalTo(wrapperView).offset(40)
            $0.centerX.equalTo(wrapperView)
        }
        dateLabel.snp.makeConstraints {
            $0.height.equalTo(21)
            $0.top.equalTo(myBadgeLabel.snp.bottom).offset(8)
            $0.centerX.equalTo(wrapperView)
        }
        badgeImageView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(22.5)
            $0.height.equalTo(195)
            $0.centerX.equalTo(wrapperView)
        }
        badgeTitleLabel.snp.makeConstraints {
            $0.height.equalTo(42)
            $0.top.equalTo(badgeImageView.snp.bottom).offset(8)
            $0.centerX.equalTo(wrapperView)
        }
        badgeDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(badgeTitleLabel.snp.bottom) // .offset(8)
            $0.centerX.equalTo(wrapperView)
            $0.bottom.equalTo(wrapperView).offset(-15.5 - 10)
        }
        
        shareButton.snp.makeConstraints {
            $0.top.equalTo(wrapperView.snp.bottom).offset(-10)
            $0.leading.trailing.equalTo(contentView).inset(24)
            $0.bottom.equalTo(contentView).offset(-36)
        }
    }
    
    override func setStyle() {
        contentView.do {
            $0.layer.cornerRadius = 56
            $0.clipsToBounds = true
        }
        closeButton.do {
            $0.setImage(UIImage.xMark, for: .normal)
        }
        myBadgeLabel.do {
            $0.text = "나의 배지"
            $0.font = UIFont.title1_b
            $0.textColor = UIColor.primary900
        }
        dateLabel.do {
            $0.text = dateParser(dateString: badge.date)
            $0.font = UIFont.body2_r
            $0.textColor = UIColor.primary700
        }
        badgeImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.setImage(url: badge.imageUrl)
        }
        badgeTitleLabel.do {
            $0.text = badge.name
            $0.font = UIFont.hakgyoansimDunggeunmisoBold_32
            $0.textColor = UIColor.primary900
        }
        badgeDescriptionLabel.do {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.lineHeightMultiple = 1.5
            let attributedString = NSAttributedString(string: badge.description, attributes: [
                .font : UIFont.body2_m,
                .foregroundColor : UIColor.gray800,
                .paragraphStyle : paragraphStyle
            ])
            $0.attributedText = attributedString
            $0.numberOfLines = 2
        }
    }
}

extension ShareBadgeModalViewController {
    
    private func setUpGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = contentView.bounds
        gradientLayer.colors = [
            UIColor(hexCode: "DAF8FF").cgColor,
            UIColor(hexCode: "7DC6F8").cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        wrapperView.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension ShareBadgeModalViewController {
    
    func setAddTarget() {
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    @objc private func shareButtonTapped() {
        kakaoShareUseCase.execute(image: wrapperView.asImage(), template: .badge).receive(on: DispatchQueue.main).sink(
            receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.showToast(message: error.message, type: .internalError)
                }
            },
            receiveValue: { _ in }
        ).store(in: &subscriptions)
    }
}

extension ShareBadgeModalViewController {
    
    private func dateParser(dateString: String) -> String? {
        let serverFormatter = DateFormatter()
        serverFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSS"
        serverFormatter.locale = Locale(identifier: "en_US_POSIX")
        serverFormatter.timeZone = TimeZone(abbreviation: "UTC")
        guard let date = serverFormatter.date(from: dateString) else {
            return nil
        }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "yyyy년 MM월 dd일"
        displayFormatter.timeZone = TimeZone.current
        return displayFormatter.string(from: date)
    }
}
