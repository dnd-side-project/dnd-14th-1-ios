//
//  LoginViewController.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/6/26.
//

import UIKit
import Then
import SnapKit
import Combine
import AuthenticationServices

final class LoginViewController: BaseViewController {
    
    // MARK: - Properties
    weak var delegate: LoginViewControllerDelegate?
    private let viewModel: LoginViewModel
    private let inputSubject = PassthroughSubject<LoginViewModel.Input, Never>()
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - UI Components
    private let contentWrapperViewLayoutGuide = UILayoutGuide()
    private let contentWrapperView = UIView()
    private let logoImageView = UIImageView(image: UIImage.logotype2)
    private let subtitleLabel = UILabel()
    private let glacierLogoImageView = UIImageView()
    private let appleLoginButton = UIButton()
    private let agreementLabel = UILabel()
    
    // MARK: - Initializer
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpGradientLogo()
        setAddTargets()
        navigationController?.navigationBar.isHidden = true
        bind()
    }
    
    private func bind() {
        viewModel.transform(inputSubject.eraseToAnyPublisher()).sink { [weak self] output in
                guard let self else { return }
                switch output {
                case let .showToast(message, type):
                    showToast(message: message, type: type)
                case .loginCompleted:
                    delegate?.didCompleteLogin()
                }
            }.store(in: &subscriptions)
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
    
    override func setStyle() {
        subtitleLabel.do {
            $0.attributedText = NSAttributedString(
                string: "가벼운 프롬프트, 단단해지는 빙하",
                attributes: [
                    .font : UIFont.body2_b,
                    .foregroundColor : UIColor.gray800
                ]
            )
            $0.textAlignment = .center
        }
        
        glacierLogoImageView.do {
            $0.image = UIImage.glacierLogo
        }
        
        appleLoginButton.do {
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
        
        agreementLabel.do {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.5
            paragraphStyle.alignment = .center
            
            $0.attributedText = NSAttributedString(
                string: "로그인하면 서비스 이용약관과 개인정보 처리방침에\n동의한 것으로 간주됩니다",
                attributes: [
                    .font : UIFont.font(.pretendardRegular, ofSize: 10),
                    .foregroundColor : UIColor.gray600,
                    .paragraphStyle : paragraphStyle
                ])
            
            $0.numberOfLines = 2
        }
    }
    
    override func addSubview() {
        [logoImageView, subtitleLabel, glacierLogoImageView].forEach {
            contentWrapperView.addSubview($0)
        }
        [contentWrapperView, appleLoginButton, agreementLabel].forEach {
            view.addSubview($0)
        }
        
        [contentWrapperViewLayoutGuide].forEach {
            view.addLayoutGuide($0)
        }
    }
    override func setLayout() {
        
        agreementLabel.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        appleLoginButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(agreementLabel.snp.top).offset(-16)
            $0.height.equalTo(60)
        }
        
        contentWrapperViewLayoutGuide.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(appleLoginButton.snp.top)
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
        appleLoginButton.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
    }
    
    @objc private func appleLoginButtonTapped() {
        handleAuthorizationAppleIDButtonPress()
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    private func handleAuthorizationAppleIDButtonPress() {
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        let request = appleIdProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            if let identityTokenData = appleIDCredential.identityToken,
               let idTokenString = String(data: identityTokenData, encoding: .utf8) {
                inputSubject.send(.login(idToken: idTokenString))
            } else {
                self.showToast(message: "알 수 없는 오류", type: .internalError)
            }
        default:
            self.showToast(message: "알 수 없는 오류", type: .internalError)
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        print("didCompleteWithError", error)
        showToast(message: "로그인에 실패했습니다", type: .internalError)
    }
}
