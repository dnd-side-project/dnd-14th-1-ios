//
//  SettingViewController.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/11/26.
//

import UIKit
import Combine
import Then
import SnapKit
import Kingfisher

protocol SettingViewControllerDelegate: AnyObject {
    func navigateToTermsOfUse()
    func navigateToPrivacyPolicy()
}

class SettingViewController: BaseViewController {
    
    // MARK: - Properties
    weak var delegate: SettingViewControllerDelegate?
    private let inputSubject = PassthroughSubject<SettingViewModel.Input, Never>()
    private var subscriptions: Set<AnyCancellable> = []
    private let viewModel: SettingViewModel
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let badgeImageBackgroundView = UIView()
    private let badgeImageView = UIImageView()
    private let changeBadgeButton = UIButton()
    
    private let nicknameStackView = UIStackView()
    private let nicknameLabel = UILabel()
    private let domainImageView = UIImageView()
    private let emailLabel = UILabel()
    
    private let separatorView = UIView()
    private let termsOfUseButton = UIButton()
    private let privacyPolicyButton = UIButton()
    private let logoutButton = UIButton()
    
    private let blurredBackgroundView = CustomVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark), intensity: 0.2)
    private let bottomSheetPresenter = BottomSheetPresenter()
    private var changeBadgeView = ChangeBadgeView()
    
    // MARK: - Initializer
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setAddTarget()
        setGesture()
        bind()
        inputSubject.send(.viewDidLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func addSubview() {
        [nicknameLabel, domainImageView].forEach {
            nicknameStackView.addArrangedSubview($0)
        }
        
        [titleLabel, badgeImageBackgroundView, badgeImageView, changeBadgeButton, nicknameStackView, emailLabel,
         separatorView, termsOfUseButton, privacyPolicyButton, logoutButton].forEach {
            contentView.addSubview($0)
        }
        
        [contentView].forEach {
            scrollView.addSubview($0)
        }
        
        [scrollView, blurredBackgroundView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        blurredBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
            $0.height.greaterThanOrEqualTo(scrollView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(24)
            $0.leading.equalTo(contentView).offset(20)
            $0.height.equalTo(32)
        }
        
        badgeImageBackgroundView.snp.makeConstraints {
            $0.size.equalTo(168)
            $0.centerX.equalTo(contentView)
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
        }
        
        badgeImageView.snp.makeConstraints {
            $0.size.equalTo(120)
            $0.center.equalTo(badgeImageBackgroundView)
        }
        
        changeBadgeButton.snp.makeConstraints {
            $0.size.equalTo(32)
            $0.trailing.equalTo(badgeImageBackgroundView).offset(-10.5)
            $0.bottom.equalTo(badgeImageBackgroundView).offset(-11)
        }
        
        nicknameStackView.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.top.equalTo(badgeImageBackgroundView.snp.bottom).offset(12)
            $0.centerX.equalTo(contentView)
        }
        
        emailLabel.snp.makeConstraints {
            $0.height.equalTo(21)
            $0.top.equalTo(nicknameStackView.snp.bottom).offset(8)
            $0.centerX.equalTo(contentView)
        }
        
        separatorView.snp.makeConstraints {
            $0.height.equalTo(4)
            $0.top.equalTo(emailLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(contentView)
        }
        
        termsOfUseButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.top.equalTo(separatorView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(contentView).inset(20)
        }
        
        privacyPolicyButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.top.equalTo(termsOfUseButton.snp.bottom)
            $0.leading.trailing.equalTo(contentView).inset(20)
        }
        
        logoutButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.centerX.equalTo(contentView)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-8)
        }
    }
    
    override func setStyle() {
        
        view.backgroundColor = UIColor(hexCode: "FAFAFA")
        
        scrollView.do {
            $0.contentInsetAdjustmentBehavior = .never
        }
        
        titleLabel.do {
            $0.attributedText = NSAttributedString(
                string: "설정",
                attributes: [
                    .font : UIFont.display2_b,
                    .foregroundColor : UIColor.gray900
                ])
        }
        
        badgeImageBackgroundView.do {
            $0.backgroundColor = UIColor.primary100
            $0.layer.cornerRadius = 84
            $0.clipsToBounds = true
        }
        
        badgeImageView.do {
            $0.contentMode = .scaleAspectFit
        }
        
        changeBadgeButton.do {
            $0.setImage(UIImage.changeBadgeButton, for: .normal)
        }
        
        nicknameStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
        }
        
        nicknameLabel.do {
            $0.font = UIFont.title3_b
            $0.textColor = UIColor.gray800
        }
        
        emailLabel.do {
            $0.textColor = UIColor.gray600
            $0.font = UIFont.body2_r
        }
        
        separatorView.do {
            $0.backgroundColor = UIColor.gray100
        }
        
        termsOfUseButton.do {
            var configuration = UIButton.Configuration.plain()
            configuration.attributedTitle = AttributedString("이용약관", attributes: AttributeContainer([
                    .font : UIFont.title3_m,
                    .foregroundColor : UIColor.gray900
                ])
            )
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 0)
            
            $0.configuration = configuration
            $0.contentHorizontalAlignment = .leading
        }
        
        privacyPolicyButton.do {
            var configuration = UIButton.Configuration.plain()
            configuration.attributedTitle = AttributedString("개인정보 처리방침", attributes: AttributeContainer([
                    .font : UIFont.title3_m,
                    .foregroundColor : UIColor.gray900
                ])
            )
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 0)
            
            $0.configuration = configuration
            $0.contentHorizontalAlignment = .leading
        }
        
        logoutButton.do {
            var configuration = UIButton.Configuration.plain()
            configuration.attributedTitle = AttributedString("로그아웃", attributes: AttributeContainer([
                .font : UIFont.label1_b,
                .foregroundColor : UIColor.negative
                ])
            )
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
            
            $0.configuration = configuration
        }
        
        blurredBackgroundView.do {
            $0.layer.opacity = 0
        }
    }
}

extension SettingViewController {
    
    private func setAddTarget() {
        changeBadgeButton.addTarget(self, action: #selector(changeBadgeButtonTapped), for: .touchUpInside)
        termsOfUseButton.addTarget(self, action: #selector(termsOfUseButtonTapped), for: .touchUpInside)
        privacyPolicyButton.addTarget(self, action: #selector(privacyPolicyButtonTapped), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    
    @objc private func changeBadgeButtonTapped() {
        showBlurredBackgroundView()
        showChangeBadgeSheet()
        inputSubject.send(.fetchBadgeList)
    }
    
    @objc private func termsOfUseButtonTapped() {
        delegate?.navigateToTermsOfUse()
    }
    
    @objc private func privacyPolicyButtonTapped() {
        delegate?.navigateToPrivacyPolicy()
    }
    
    @objc private func logoutButtonTapped() {
        let alert = UIAlertController(title: "로그아웃 하시겠습니까?", message: nil, preferredStyle: .alert)
        let close = UIAlertAction(title: "닫기", style: .default)
        let confirm = UIAlertAction(title: "확인", style: .destructive) { [weak self] _ in
            self?.inputSubject.send(.handleLogout)
        }
        [close, confirm].forEach {
            alert.addAction($0)
        }
        present(alert, animated: true)
    }
    
    private func showChangeBadgeSheet() {
        
        let sheetHeight = view.frame.height * 0.75
        changeBadgeView = ChangeBadgeView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: sheetHeight))
        
        changeBadgeView.onChangeBadgeButtonTapped = { [weak self] selectedBadgeId in
            print(selectedBadgeId) // TODO: ViewModel에 알리기
            self?.bottomSheetPresenter.dismissSheet()
        }
        
        bottomSheetPresenter.onDissmiss = hideBlurredBackgroundView
        
        bottomSheetPresenter.presentOnTop(
            contentView: changeBadgeView,
            height: sheetHeight
        )
    }
    
    private func setGesture() {
        blurredBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissBottomSheet)))
    }
    
    @objc private func dismissBottomSheet() {
        hideBlurredBackgroundView()
        bottomSheetPresenter.dismissSheet()
    }
    
    private func showBlurredBackgroundView() {
        UIView.transition(with: blurredBackgroundView,
                          duration: 0.2) { [weak self] in
            self?.blurredBackgroundView.layer.opacity = 1
        }
    }
    
    private func hideBlurredBackgroundView() {
        UIView.transition(with: blurredBackgroundView,
                          duration: 0.2) { [weak self] in
            self?.blurredBackgroundView.layer.opacity = 0
        }
    }
}

extension SettingViewController {
    
    private func bind() {
        viewModel.transform(with: inputSubject.eraseToAnyPublisher()).sink { [weak self] output in
            guard let self else { return }
            switch output {
            case let .updateUserProfile(userProfile):
                updateUserProfile(userProfile)
            case let .updateBadgeList(badgeList):
                updateBadgeList(badgeList)
            }
        }.store(in: &subscriptions)
    }
}

extension SettingViewController {
    
    private func updateUserProfile(_ userProfile: UserProfile) {

        badgeImageView.setImage(url: userProfile.imageUrl)
        nicknameLabel.text = userProfile.nickname
        emailLabel.text = userProfile.email
        
        let domainImage: UIImage
        switch userProfile.domain {
        case .apple:
            domainImage = UIImage.apple.withTintColor(.black)
        case .google:
            domainImage = UIImage.google
        }
        domainImageView.do {
            $0.image = domainImage
        }
    }
    
    private func updateBadgeList(_ badges: [Badge]) {
        changeBadgeView.configure(badges)
    }
    
}
