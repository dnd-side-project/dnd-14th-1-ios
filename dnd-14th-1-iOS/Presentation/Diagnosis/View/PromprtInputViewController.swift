//
//  PromprtInputViewController.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/15/26.
//

import UIKit

import SnapKit
import Then

final class PromprtInputViewController: BaseViewController {
    
    private let topIndicator = UIView()
    
    var onDismiss: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        onDismiss?()
    }
    
    override func setStyle() {
        view.backgroundColor = .primary400
        
        topIndicator.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 3
        }
    }
    
    override func addSubview() {
        view.addSubviews(topIndicator)
    }
    
    override func setLayout() {
        topIndicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(16)
            $0.width.equalTo(80)
            $0.height.equalTo(5)
        }
    }
}
