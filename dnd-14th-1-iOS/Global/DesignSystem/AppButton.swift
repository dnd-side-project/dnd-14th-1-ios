//
//  AppButton.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/8/26.
//

import UIKit

final class AppButton: UIButton {
    
    enum Style {
        case primary
        case secondary
    }
    
    enum Size: CGFloat {
        case large = 60
        case medium = 40
    }
    
    // MARK: - Properties
    private let imageSize = CGSize(width: 20, height: 20)
    private let style: Style
    private let size: Size
    
    // MARK: - Initializer
    init(style: Style = .primary, size: Size, title: String, image: UIImage?) {
        self.style = style
        self.size = size
        
        super.init(frame: .zero)
        
        setConfiguration(title: title, image: image)
        self.configurationUpdateHandler = updateConfiguration(_:)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AppButton {
    
    private func setConfiguration(title: String, image: UIImage?) {
        var configuration = UIButton.Configuration.plain()
        
        // Image
        if let image {
            configuration.image = image.resized(to: imageSize)
            configuration.imagePadding = 4
            configuration.imagePlacement = .leading
        }
        // Title
        configuration.title = title
        configuration.titleLineBreakMode = .byTruncatingTail
        // Background
        configuration.background.cornerRadius = intrinsicContentSize.height / 2
        
        self.configuration = configuration
    }
    
    private func updateConfiguration(_ button: UIButton) {
        guard let appButton = button as? AppButton,
              var configuration = appButton.configuration,
              let title = configuration.title else {
            return
        }
        
        let foregroundColor = foregroundColor()
        let backgroundColor = backgroundColor()
        
        // Image
        if let image = configuration.image {
            configuration.image = image.withTintColor(foregroundColor)
        }
        // Title
        configuration.attributedTitle = AttributedString(title, attributes: AttributeContainer([
            .foregroundColor : foregroundColor,
            .font : UIFont.label1_b
        ]))
        // Background
        configuration.background.backgroundColor = backgroundColor
        
        appButton.configuration = configuration
    }
}

extension AppButton {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: size.rawValue)
    }
    
    private func foregroundColor() -> UIColor {
        if state.contains(.disabled) {
            return UIColor.gray500
        }
        if state.contains(.highlighted) {
            return UIColor.white
        }
        
        switch style {
        case .primary : return UIColor.white
        case .secondary : return UIColor.gray700
        }
    }
    
    private func backgroundColor() -> UIColor {
        if state.contains(.disabled) {
            return UIColor.gray300
        }
        if state.contains(.highlighted) {
            return UIColor.primary800
        }
        
        switch style {
        case .primary : return UIColor.primary900
        case .secondary : return UIColor.gray200
        }
    }
}
