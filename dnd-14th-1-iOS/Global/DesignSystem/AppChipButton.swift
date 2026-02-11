//
//  AppChipButton.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/10/26.
//

import UIKit

final class AppChipButton: UIButton {
    
    // MARK: - Properties
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 88, height: 40)
    }
    
    // MARK: - Initializer
    init(title: String) {
        super.init(frame: .zero)
        setConfiguration(title)
        configurationUpdateHandler = { [weak self] button in
            self?.updateConfiguration(button)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AppChipButton {
    
    private func setConfiguration(_ title: String) {
        var configuration = UIButton.Configuration.plain()
        
        // title
        configuration.title = title
        // background
        configuration.background.cornerRadius = 20
        self.configuration = configuration
    }
    
    private func updateConfiguration(_ button: UIButton) {
        guard let appChipButton = button as? AppChipButton,
              var configuration = appChipButton.configuration,
              let title = configuration.title else {
            return
        }
        
        let foregroundColor = appChipButton.foregroundColor()
        let backgroundColor = appChipButton.backgroundColor()
        
        // title
        configuration.attributedTitle = AttributedString(title, attributes: AttributeContainer([
            .font : UIFont.label1_b,
            .foregroundColor : foregroundColor
        ]))
        // background
        configuration.background.backgroundColor = backgroundColor
        
        appChipButton.configuration = configuration
    }
}

extension AppChipButton {
    
    private func foregroundColor() -> UIColor {
        if state.contains(.selected) {
            return UIColor.gray50
        } else {
            return UIColor.gray500
        }
    }
    
    private func backgroundColor() -> UIColor {
        if state.contains(.selected) {
            return UIColor.primary900
        } else {
            return UIColor(hexCode: "EDEDED")
        }
    }
}
