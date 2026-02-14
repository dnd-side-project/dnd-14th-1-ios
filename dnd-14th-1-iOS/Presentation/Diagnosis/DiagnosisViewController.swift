//
//  DiagnosisViewController.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/11/26.
//

import UIKit

import SnapKit
import Then

final class DiagnosisViewController: BaseViewController {
    
    private lazy var promptButton = UIButton().then {
        $0.setTitle("프롬프트 진단", for: .normal)
        $0.addTarget(self, action: #selector(promptButtonTapped), for: .touchUpInside)
    }
    
    weak var delegate: DiagnosisViewControllerDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.        
    }
    
    override func addSubview() {
        view.addSubview(promptButton)
    }
    
    override func setLayout() {
        promptButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    @objc private func promptButtonTapped() {        
        delegate?.didTapPromptButton()
    }
}
