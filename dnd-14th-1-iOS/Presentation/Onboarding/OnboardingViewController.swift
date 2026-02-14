//
//  OnboardingViewController.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/6/26.
//

import UIKit
import Then
import SnapKit

final class OnboardingViewController: BaseViewController {
    
    let button = UIButton().then {
        $0.setTitle("home", for: .normal)
        $0.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        configureView()
    }
    
    @objc private func buttonTapped() {
        
//        navigationController?.setViewControllers([homeTabbarController], animated: true)
    }
    
    private func configureView() {
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
