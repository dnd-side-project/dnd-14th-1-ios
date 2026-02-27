//
//  EcoViewController.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/11/26.
//

import UIKit
import Combine
import SnapKit
import Then

protocol EcoViewControllerDelegate: AnyObject {
    func presentShareBadge(badge: Badge)
    func presentShareTier(tier: EcoTier)
}

class EcoViewController: BaseViewController {
    
    // MARK: - Properties
    weak var delegate: EcoViewControllerDelegate?
    private let viewModel: EcoViewModel
    private let inputSubject = PassthroughSubject<EcoViewModel.Input, Never>()
    private var subscriptions: Set<AnyCancellable> = []
    private var didLayoutSubviews = false
    
    private var ecoTier: EcoTier?
    
    // MARK: - UI Components
    private let titleLabel = UILabel()
    private let badgeImageView = UIImageView()
    private let untilNextTierLabel = UILabel()
    private let tierProgressBackgroundView = UIView()
    private let tierProgessBarView = UIView()
    private let tierLabel = UILabel()
    private let shareTierButton = AppButton(size: .medium, title: "티어 공유하기", image: UIImage.shareNetwork)
    
    private let gradientBackgroundLayer = CAGradientLayer()
    
    private var myBadgesView = MyBadgesView()
    private let bottomSheetPresenter = ExpandableBottomSheetPresenter()
    
    // MARK: - Initialzier
    init(viewModel: EcoViewModel) {
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
        bind()
        inputSubject.send(.viewDidLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !didLayoutSubviews {
            setUpGradientBackground()
            setUpTierProgressBarGradientBackground()
            showBottomSheet()
            didLayoutSubviews = true
        }
    }
    
    // MARK: - Bind
    private func bind() {
        viewModel.transform(inputSubject.eraseToAnyPublisher()).receive(on: DispatchQueue.main).sink { [weak self] output in
            guard let self else { return }
            switch output {
            case let .showToast(message, type):
                showToast(message: message, type: type)
            case let .updateBadges(badges):
                myBadgesView.configure(badges: badges)
            case let .updateEcoTier(ecoTier):
                updateEcoTier(ecoTier)
            }
        }.store(in: &subscriptions)
    }
    
    // MARK: - Base
    override func addSubview() {
        [titleLabel, badgeImageView, untilNextTierLabel, tierProgressBackgroundView, tierProgessBarView, tierLabel, shareTierButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        view.backgroundColor = UIColor(hexCode: "E5F6FF")
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(37)
            $0.leading.equalToSuperview().offset(20)
        }
        
        badgeImageView.snp.makeConstraints {
            $0.width.equalTo(159)
            $0.height.equalTo(146)
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.equalTo(titleLabel)
        }
        
        untilNextTierLabel.snp.makeConstraints {
            $0.height.equalTo(18)
            $0.top.equalTo(badgeImageView)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        tierProgressBackgroundView.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.width.equalTo(156)
            $0.trailing.equalTo(untilNextTierLabel)
            $0.top.equalTo(untilNextTierLabel.snp.bottom).offset(4)
        }
        
        tierProgessBarView.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.width.equalTo(100)
            $0.top.leading.equalTo(tierProgressBackgroundView)
        }
        
        tierLabel.snp.makeConstraints {
            $0.height.equalTo(42)
            $0.trailing.equalTo(untilNextTierLabel)
            $0.top.equalTo(tierProgressBackgroundView.snp.bottom).offset(12)
        }
        
        shareTierButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.trailing.equalTo(untilNextTierLabel)
            $0.top.equalTo(tierLabel.snp.bottom).offset(14)
        }
    }
    
    override func setStyle() {
        titleLabel.do {
            $0.text = "나의 에코"
            $0.textColor = UIColor.gray900
            $0.font = UIFont.display2_b
        }
        
        badgeImageView.do {
            $0.contentMode = .scaleAspectFit
        }
        
        tierProgressBackgroundView.do {
            $0.backgroundColor = UIColor.commonWhite
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
            $0.layer.applySketchShadow(color: UIColor(hexCode: "171717"), alpha: 0.15, x: 0, y: 0, blur: 4, spread: 0)
            $0.layer.masksToBounds = false
        }
        
        tierProgessBarView.do {
            $0.layer.applySketchShadow(color: UIColor(hexCode: "171717"), alpha: 0.15, x: 0, y: 0, blur: 4, spread: 0)
            $0.layer.masksToBounds = false
        }
    }

    private func setUpGradientBackground() {
        gradientBackgroundLayer.frame = view.bounds
        gradientBackgroundLayer.colors = [
            UIColor(hexCode: "4267D8").cgColor,
            UIColor(hexCode: "07BBE3").cgColor
        ]
        gradientBackgroundLayer.startPoint = CGPoint(x: 0, y: 0.2)
        gradientBackgroundLayer.endPoint = CGPoint(x: 1, y: 0)
        view.layer.addSublayer(gradientBackgroundLayer)
        gradientBackgroundLayer.opacity = 0
    }
    
    private func setUpTierProgressBarGradientBackground() {
        tierProgessBarView.do {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = $0.bounds
            gradientLayer.colors = [
                UIColor(hexCode: "7DC6F8").cgColor,
                UIColor(hexCode: "825CF4").cgColor
            ]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            $0.layer.addSublayer(gradientLayer)
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
    }
}

extension EcoViewController {
    
    private func setAddTarget() {
        shareTierButton.addTarget(self, action: #selector(shareTierButtonTapped), for: .touchUpInside)
    }

    @objc private func shareTierButtonTapped() {
        if let ecoTier {
            delegate?.presentShareTier(tier: ecoTier)
        }
    }
}

extension EcoViewController {
    
    private func showBottomSheet() {
        let sheetHeight: CGFloat = view.frame.height - (badgeImageView.frame.maxY + 32.5) - view.safeAreaInsets.bottom
        myBadgesView =  MyBadgesView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: sheetHeight))
        myBadgesView.didTapBadgePublisher.receive(on: DispatchQueue.main).sink { [weak self] badge in
            self?.delegate?.presentShareBadge(badge: badge)
        }.store(in: &subscriptions)
        
        bottomSheetPresenter.onMaximize = { [weak self] in
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.95,
                initialSpringVelocity: 0.7,
                animations: {
                    self?.gradientBackgroundLayer.opacity = 1
                }
            )
        }
        bottomSheetPresenter.onRestore = { [weak self] in
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.95,
                initialSpringVelocity: 0.7,
                animations: {
                    self?.gradientBackgroundLayer.opacity = 0
                }
            )
        }

        bottomSheetPresenter.present(
            on: self,
            contentView: myBadgesView,
            height: sheetHeight,
            isDismissPermitted: false
        )
    }
}

extension EcoViewController {
    
    private func updateEcoTier(_ ecoTier: EcoTier) {
        self.ecoTier = ecoTier
        
        badgeImageView.do {
            $0.setImage(url: ecoTier.data.imageUrl)
        }
        
        untilNextTierLabel.do {
            let description = "다음 등급까지 "
            let amount = "\(ecoTier.data.nextTierXP - ecoTier.data.currentTierXP)"
            let kg = "kg"
            let fullText = description + amount + kg
            let attributedString = NSMutableAttributedString(string: fullText)
            
            let descriptionRange = (fullText as NSString).range(of: description)
            attributedString.addAttributes([
                .font : UIFont.body2_r,
                .foregroundColor : UIColor.gray500
            ], range: descriptionRange)
            
            let amountRange = (fullText as NSString).range(of: amount)
            attributedString.addAttributes([
                .font : UIFont.hakgyoansimDunggeunmisoBold_14,
                .foregroundColor : UIColor.gray900
            ], range: amountRange)
            
            let kgRange = (fullText as NSString).range(of: kg)
            attributedString.addAttributes([
                .font : UIFont.hakgyoansimDunggeunmisoRegular_14,
                .foregroundColor : UIColor.gray900
            ], range: kgRange)
            
            $0.attributedText = attributedString
        }
        
        tierLabel.do {
            let title = "Eco Tier "
            let tier = "\(ecoTier.data.tier)"
            let fullText = title + tier
            
            let attributedString = NSMutableAttributedString(string: fullText)
            
            let titleRange = (fullText as NSString).range(of: title)
            attributedString.addAttributes([
                .foregroundColor : UIColor.gray800,
                .font : UIFont.headline1_b
            ], range: titleRange)
            
            let tierRange = (fullText as NSString).range(of: tier)
            attributedString.addAttributes([
                .foregroundColor : UIColor.primary550,
                .font : UIFont.hakgyoansimDunggeunmisoBold_40
            ], range: tierRange)
            
            $0.attributedText = attributedString
        }
    }
}
