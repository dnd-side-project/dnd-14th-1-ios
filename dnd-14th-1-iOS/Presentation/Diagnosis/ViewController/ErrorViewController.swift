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
        
    private let animationView = LottieAnimationView(name: "lottie_failerror")
    private let errorText = UILabel()
    private let errorSubText = UILabel()
    private let retryButton = AppButton(size: .large, title: "다시 입력하기", image: nil)
    
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
    }
    
    override func addSubview() {
        view.addSubviews(
            animationView,
            errorText,
            errorSubText,
            retryButton
        )
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
    }
    
    override func setLayout() {
        animationView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(237)
        }
        
        errorText.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(animationView.snp.bottom).offset(24)
        }
        
        errorSubText.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(errorText.snp.bottom).offset(12)
        }
        
        retryButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func addTargets() {
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
    }
    
    @objc private func retryButtonTapped() {
        onRetry?()
    }
}
