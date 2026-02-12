//
//  SplashViewController.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/10/26.
//

import UIKit
import Then
import SnapKit

final class SplashViewController: BaseViewController {
    
    // MARK: - UI Components
    let gradientLayer = CAGradientLayer().then {
        $0.isHidden = true
    }
    
    private let subtitleLabel = UILabel().then {
        $0.attributedText = NSAttributedString(
            string: "가벼운 프롬프트, 단단해지는 빙하",
            attributes: [
                .font : UIFont.body2_b,
                .foregroundColor : UIColor(hexCode: "FFFFFF")
            ]
        )
        $0.textAlignment = .center
    }
    private let logoImageView = UIImageView(image: UIImage.logotype1)
    
    // MARK: - Life Cycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if gradientLayer.isHidden {
            setUpGradientBackground()
        }
    }
    
    private func setUpGradientBackground() {
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.primary500.cgColor,
            UIColor(hexCode: "9BD7FF").cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        gradientLayer.isHidden = false
    }
    
    override func addSubview() {
        [subtitleLabel, logoImageView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        subtitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(21)
            $0.bottom.equalTo(logoImageView.snp.top)
        }
    }
}

