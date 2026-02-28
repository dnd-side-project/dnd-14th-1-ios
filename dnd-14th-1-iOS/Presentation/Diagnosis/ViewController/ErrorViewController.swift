//
//  ErrorViewController.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/23/26.
//

import UIKit

import SnapKit
import Then
import Lottie

final class ErrorViewController: BaseViewController {
    
    var retryButtonText: String {
        get { retryButton.currentTitle ?? "" }
        set { retryButton.setTitle(newValue, for: .normal)}
    }
        
    private let layoutGuide = UILayoutGuide()
    private let animationView = LottieAnimationView(name: "lottie_failerror")
    private let errorText = UILabel()
    private let errorSubText = UILabel()
    private let retryButton = AppButton(size: .large, title: "다시 입력하기", image: nil)
    private let dummyView = UIView()
    
    var onRetry: (() -> Void)?
    
    init(title: String, description: String) {
        errorText.text = title
        errorSubText.text = description
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.play()
        animationView.loopMode = .loop
        addTargets()
    }
    
    override func addSubview() {
        view.addSubviews(
            animationView,
            errorText,
            errorSubText,
            retryButton,
            dummyView
        )
        view.addLayoutGuide(layoutGuide)
    }
    
    override func setStyle() {
        view.backgroundColor = .gray50
        
        errorText.do {
            $0.font = .title1_b
            $0.textColor = .gray800
        }
        
        errorSubText.do {
            $0.font = .title3_r
            $0.textColor = .gray500
        }
        
        dummyView.do {
            $0.backgroundColor = .gray50
        }
    }
    
    override func setLayout() {
        
        layoutGuide.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        animationView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(layoutGuide)
        }
        
        errorText.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(animationView.snp.bottom).offset(24)
        }
        
        errorSubText.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(errorText.snp.bottom).offset(12)
            $0.bottom.equalTo(layoutGuide)
        }
        
        retryButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        dummyView.snp.makeConstraints {
            $0.trailing.bottom.equalTo(animationView)
            $0.height.equalTo(40)
            $0.width.equalTo(90)
        }
    }
    
    private func addTargets() {
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
    }
    
    @objc private func retryButtonTapped() {
        onRetry?()
    }
}
