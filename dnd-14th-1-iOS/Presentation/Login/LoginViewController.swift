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
    
    let button = UIButton().then {
        $0.setTitle("onboarding", for: .normal)
        $0.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        configureView()
    }
    
    @objc private func buttonTapped() {
        let onboardingViewController = OnboardingViewController()
        navigationController?.setViewControllers([onboardingViewController], animated: true)
    }
    
    private func configureView() {
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
