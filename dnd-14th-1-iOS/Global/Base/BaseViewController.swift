//
//  BaseViewController.swift
//  dnd-14th-1-iOS
//
//  Created by a on 1/31/26.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - Initilizing
    
    var backButtonColor: UIColor = .black
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
            
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .black
        addSubview()
        setLayout()
        setDelegate()
        setStyle()
        setNavigationBarStyle()
    }
    
    // addSubview
    func addSubview() {}
    // set Constraints
    func setLayout() {}
    // set Delegate
    func setDelegate() {}
    // set style
    func setStyle() {}
    
    func setNavigationBarStyle() {
        let backButton = UIImage(resource: .backButton).withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0))
    
        navigationController?.navigationBar.backIndicatorImage = backButton
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButton
                
        navigationItem.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.tintColor = backButtonColor
    }
}
