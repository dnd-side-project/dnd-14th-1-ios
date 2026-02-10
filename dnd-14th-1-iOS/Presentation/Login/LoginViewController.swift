//
//  LoginViewController.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/6/26.
//

import UIKit
import Then
import SnapKit

final class LoginViewController: BaseViewController {
    
    // MARK: - UI Components
    private let contentWrapperViewLayoutGuide = UILayoutGuide()
    
    private let contentWrapperView = UIView()
    
    private let logoImageView = UIImageView(image: UIImage.logotype2)
    
    private let subtitleLabel = UILabel().then {
        $0.attributedText = NSAttributedString(
            string: "가벼운 프롬프트, 단단해지는 빙하",
            attributes: [
                .font : UIFont.body2_b,
                .foregroundColor : UIColor.gray800
            ]
        )
        $0.textAlignment = .center
    }
    
    private let glacierLogoImageView = UIImageView().then {
        $0.image = UIImage.glacierLogo
    }
    
    private let googleLoginButton = UIButton().then {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage.google
        configuration.attributedTitle = AttributedString("Google 계정으로 로그인", attributes: AttributeContainer([
            .font : UIFont.label1_m,
            .foregroundColor : UIColor.gray900
        ]))
        configuration.imagePadding = 8
        configuration.imagePlacement = .leading
        configuration.background.backgroundColor = UIColor.gray50
        configuration.background.cornerRadius = 30
        $0.configuration = configuration
        $0.layer.cornerRadius = 30
        $0.layer.borderColor = UIColor.gray400.cgColor
        $0.layer.borderWidth = 1
        $0.clipsToBounds = true
    }
    
    private let appleLoginButton = UIButton().then {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage.apple
        configuration.attributedTitle = AttributedString("Apple로 로그인", attributes: AttributeContainer([
            .font : UIFont.label1_m,
            .foregroundColor : UIColor.gray50
        ]))
        configuration.imagePadding = 8
        configuration.imagePlacement = .leading
        configuration.background.backgroundColor = UIColor.gray900
        configuration.background.cornerRadius = 30
        $0.configuration = configuration
        $0.clipsToBounds = true
    }
    
    private let agreementLabel = UILabel().then {
        let text = "로그인하면 서비스 이용약관과 개인정보 처리방침에\n동의한 것으로 간주됩니다"
        $0.setTextWithLineHeight(text: text, lineHeight: 17.0)
        let mutableAttributedString = $0.attributedText?.mutableCopy() as? NSMutableAttributedString
        mutableAttributedString?.addAttributes(
            [
                .font : UIFont.font(.pretendardRegular, ofSize: 10),
                .foregroundColor : UIColor.gray600
            ],
            range: NSRange(location: 0, length: text.count)
        )
        $0.attributedText = mutableAttributedString
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpGradientLogo()
        setAddTargets()
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setUpGradientLogo() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.primary500.cgColor,
            UIColor(hexCode: "6FB0FF").cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        gradientLayer.frame = logoImageView.frame
        
        let mask = CALayer()
        mask.contents = UIImage.logotype2.cgImage
        mask.frame = gradientLayer.bounds
        gradientLayer.mask = mask
        
        logoImageView.layer.addSublayer(gradientLayer)
    }
    
    override func addSubview() {
        [logoImageView, subtitleLabel, glacierLogoImageView].forEach {
            contentWrapperView.addSubview($0)
        }
        [contentWrapperView, googleLoginButton, appleLoginButton, agreementLabel].forEach {
            view.addSubview($0)
        }
        
        [contentWrapperViewLayoutGuide].forEach {
            view.addLayoutGuide($0)
        }
    }
    override func setLayout() {
        
        agreementLabel.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
            $0.centerX.equalToSuperview()
        }
        appleLoginButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(agreementLabel.snp.top).offset(-16)
            $0.height.equalTo(60)
        }
        googleLoginButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(appleLoginButton.snp.top).offset(-8)
            $0.height.equalTo(60)
        }
        
        contentWrapperViewLayoutGuide.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(googleLoginButton.snp.top)
        }
        
        logoImageView.snp.makeConstraints {
            $0.top.centerX.equalTo(contentWrapperView)
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(8)
            $0.centerX.equalTo(contentWrapperView)
            $0.height.equalTo(21)
        }
        glacierLogoImageView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(48)
            $0.centerX.bottom.equalTo(contentWrapperView)
        }
        
        contentWrapperView.snp.makeConstraints {
            $0.center.equalTo(contentWrapperViewLayoutGuide)
        }
    }
}

extension LoginViewController {
    
    private func setAddTargets() {
        googleLoginButton.addTarget(self, action: #selector(googleLoginButtonTapped), for: .touchUpInside)
        appleLoginButton.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
    }
    
    @objc private func googleLoginButtonTapped() {
        navigateToOnboarding()
    }
    @objc private func appleLoginButtonTapped() {
        navigateToOnboarding()
    }
}

extension LoginViewController {
    
    private func navigateToOnboarding() {
        let viewController = OnboardingViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
