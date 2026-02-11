//
//  OnBoardingPageControl.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/10/26.
//

import UIKit
import Combine
import Then
import SnapKit

final class OnboardingPageControl: UIView {
    
    // MARK: - Properties
    let lastPagePublihser = PassthroughSubject<Bool, Never>()
    
    private let currentIndicatorSize = CGSize(width: 20, height: 8)
    private let indicatorSize = CGSize(width: 8, height: 8)
    
    private let currentIndicatorColor = UIColor.primary400
    private let indicatorColor = UIColor.gray200
    
    var numberOfPages: Int = 0 {
        didSet {
            indicators.removeAll()
            for _ in 0..<numberOfPages {
                let indicator = UIView().then {
                    $0.backgroundColor = indicatorColor
                    $0.layer.cornerRadius = 4
                }
                indicators.append(indicator)
            }
            addSubview()
            setLayout()
            
            indicators[0].backgroundColor = currentIndicatorColor
            indicators[0].snp.updateConstraints {
                $0.size.equalTo(currentIndicatorSize)
            }
            self.layoutIfNeeded()
        }
    }
    var currentPage: Int = 0 {
        willSet {
            guard currentPage != newValue,
               currentPage < numberOfPages else {
                return
            }
            setUpIndicator(indicators[currentPage])
        }
        didSet {
            guard currentPage != oldValue,
                  currentPage < numberOfPages else {
                return
            }
            setUpCurrentIndicator(indicators[currentPage])
            
            lastPagePublihser.send(currentPage == numberOfPages - 1)
        }
    }
    
    // MARK: - UI Components
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 12
    }
    
    private var indicators: [UIView] = []
}

extension OnboardingPageControl {
    
    private func setUpIndicator (_ indicator: UIView) {
        
        UIView.animate(springDuration: 0.2, bounce: 0.2) { [weak self] in
            guard let self else { return }
            indicator.backgroundColor = indicatorColor
            indicator.snp.remakeConstraints { [weak self] in
                guard let self else { return }
                $0.size.equalTo(indicatorSize)
            }
            layoutIfNeeded()
        }
    }
    
    private func setUpCurrentIndicator (_ currentIndicator: UIView) {
        
        UIView.animate(springDuration: 0.2, bounce: 0.2) { [weak self] in
            guard let self else { return }
            currentIndicator.backgroundColor = currentIndicatorColor
            currentIndicator.snp.updateConstraints { [weak self] in
                guard let self else { return }
                $0.size.equalTo(currentIndicatorSize)
            }
            layoutIfNeeded()
        }
    }
}

extension OnboardingPageControl {
    
    func addSubview() {
        
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        indicators.forEach {
            stackView.addArrangedSubviews($0)
        }
        addSubview(stackView)
    }
    
    func setLayout() {
        stackView.arrangedSubviews.forEach {
            $0.snp.makeConstraints {
                $0.size.equalTo(CGSize(width: 8, height: 8))
            }
        }
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}
