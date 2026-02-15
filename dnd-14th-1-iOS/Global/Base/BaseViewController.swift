//
//  BaseViewController.swift
//  dnd-14th-1-iOS
//
//  Created by a on 1/31/26.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - Initilizing
    
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
    }
    
    // addSubview
    func addSubview() {}
    // set Constraints
    func setLayout() {}
    // set Delegate
    func setDelegate() {}
    // set style
    func setStyle() {}
}
