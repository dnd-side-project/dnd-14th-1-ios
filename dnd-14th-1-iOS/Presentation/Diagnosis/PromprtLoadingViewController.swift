//
//  PromprtLoadingViewController.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/15/26.
//

import UIKit

final class PromprtLoadingViewController: UIViewController {
    weak var delegate: PromptLoadingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startPromptDiagnosis()
    }
    
    private func startPromptDiagnosis() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            self?.delegate?.didCompleteDiagnosis()
        }
    }
}
