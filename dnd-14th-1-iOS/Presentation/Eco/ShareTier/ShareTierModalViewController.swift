//
//  ShareTierModalViewController.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/27/26.
//

import UIKit
import Combine
import SnapKit
import Then
import Photos

final class ShareTierModalViewController: BaseViewController {
    
    // MARK: - Properties
    private let tier: EcoTier
    
    // MARK: - UI Components
    private let blurredBackgroundView = CustomVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark), intensity: 0.2)
    private let contentView = UIView()
    
    private let wrapperView = UIView()
    private let closeButton = UIButton()
    private let titleLabel = UILabel()
    private let tierLabel = UILabel()
    private let glacierImageView = UIImageView()
    private let descriptionLabel = UILabel()
    private let kakaoShareButton = UIButton()
    private let imageDownloadButton = UIButton()
    
    // MARK: - Initializer
    init(tier: EcoTier) {
        self.tier = tier
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
    
    // MARK: - Base
    override func addSubview() {
        [titleLabel, tierLabel, glacierImageView, descriptionLabel].forEach {
            wrapperView.addSubview($0)
        }
        [closeButton, wrapperView, kakaoShareButton, imageDownloadButton].forEach {
            contentView.addSubview($0)
        }
        [blurredBackgroundView, contentView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        blurredBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        closeButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.top.equalTo(contentView).offset(24)
            $0.trailing.equalTo(contentView).offset(-24)
        }
        
        wrapperView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(contentView)
        }
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(31)
            $0.top.equalTo(wrapperView).offset(48)
            $0.centerX.equalTo(wrapperView)
        }
        tierLabel.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalTo(wrapperView)
        }
        glacierImageView.snp.makeConstraints {
            $0.height.equalTo(243)
            $0.top.equalTo(tierLabel.snp.bottom).offset(40)
            $0.leading.trailing.equalTo(wrapperView)
        }
        descriptionLabel.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.top.equalTo(glacierImageView.snp.bottom).offset(40)
            $0.centerX.equalTo(wrapperView)
            $0.bottom.equalTo(wrapperView).offset(-24)
        }
        
        kakaoShareButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.top.equalTo(wrapperView.snp.bottom)
            $0.leading.equalTo(contentView).offset(16)
            $0.trailing.equalTo(imageDownloadButton.snp.leading).offset(-8)
            $0.bottom.equalTo(contentView).offset(-32)
        }
        imageDownloadButton.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.top.bottom.equalTo(kakaoShareButton)
            $0.trailing.equalTo(contentView).offset(-16)
        }
    }
    
    override func setStyle() {
        view.backgroundColor = .clear
        
        contentView.do {
            $0.backgroundColor = UIColor(hexCode: "FAFAFA")
            $0.layer.cornerRadius = 28
            $0.clipsToBounds = true
        }
        closeButton.do {
            $0.setImage(UIImage.xMark, for: .normal)
        }
        titleLabel.do {
            $0.text = "나의 에코 티어는"
            $0.font = UIFont.headline3_b
            $0.textColor = UIColor.gray700
        }
        tierLabel.do {
            let title = "Eco Tier "
            let tier = "\(tier.data.tier)"
            let fullText = title + tier
            
            let attributedString = NSMutableAttributedString(string: fullText)
            
            let titleRange = (fullText as NSString).range(of: title)
            attributedString.addAttributes([
                .font : UIFont.display1_b,
                .foregroundColor : UIColor.primary550
            ], range: titleRange)
            
            let tierRange = (fullText as NSString).range(of: tier)
            attributedString.addAttributes([
                .font : UIFont.hakgyoansimDunggeunmisoBold_44,
                .foregroundColor : UIColor.primary550
            ], range: tierRange)
            
            $0.attributedText = attributedString
        }
        glacierImageView.do {
            $0.setImage(url: tier.data.imageUrl)
            $0.contentMode = .scaleAspectFit
        }
        descriptionLabel.do {
            $0.text = tier.data.description
            $0.font = UIFont.body1_m
            $0.textColor = UIColor.gray900
        }
        kakaoShareButton.do {
            var configuration = UIButton.Configuration.plain()
            configuration.image = UIImage.kakao
            configuration.attributedTitle = AttributedString("카카오톡 공유", attributes: AttributeContainer([
                .font : UIFont.label1_b,
                .foregroundColor : UIColor.gray800
            ]))
            configuration.imagePadding = 4
            configuration.background.backgroundColor = UIColor(hexCode: "FAE100")
            configuration.background.cornerRadius = 30
            $0.configuration = configuration
        }
        imageDownloadButton.do {
            $0.setImage(UIImage.download, for: .normal)
            $0.backgroundColor = UIColor.gray200
            $0.layer.cornerRadius = 30
            $0.clipsToBounds = true
        }
    }
}

extension ShareTierModalViewController {
    
    private func setAddTarget() {
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        kakaoShareButton.addTarget(self, action: #selector(kakaoShareButtonTapped), for: .touchUpInside)
        imageDownloadButton.addTarget(self, action: #selector(imageDownloadButtonTapped), for: .touchUpInside)
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    @objc private func kakaoShareButtonTapped() {}
}

extension ShareTierModalViewController {
    
    @objc private func imageDownloadButtonTapped() {
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        
        switch status {
        case .authorized, .limited:
            saveImage()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
                DispatchQueue.main.async { [weak self] in
                    if newStatus == .authorized {
                        self?.saveImage()
                    } else {
                        self?.showToast(message: "설정에서 사진 접근을 허용해주세요", type: .internalError)
                    }
                }
            }
        default:
            showToast(message: "설정에서 사진 접근을 허용해주세요", type: .internalError)
        }
    }
    
    private func saveImage() {
        UIImageWriteToSavedPhotosAlbum(
            wrapperView.asImage(),
            self,
            #selector(saveImageCompletion(image:didFinishSavingWithError:contextInfo:)),
            nil
        )
    }
    
    @objc private func saveImageCompletion(image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let _ = error {
            showToast(message: "나의 에코를 저장하지 못했어요", type: .internalError)
        } else {
            showToast(message: "나의 에코를 저장했어요", type: .networkError)
        }
    }
}
