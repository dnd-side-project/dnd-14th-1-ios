//
//  UILabel+.swift
//  dnd-14th-1-iOS
//
//  Created by a on 1/31/26.
//

import UIKit

extension UILabel {
    
    func setLabel(
        text: String? = "",
        alignment: NSTextAlignment = .center,
        numberOfLines: Int = 0,
        textColor: UIColor,
        font: UIFont,
        backgroundColor: UIColor? = .clear
    ) {
        self.text = text
        self.textAlignment = alignment
        self.numberOfLines = numberOfLines
        self.textColor = textColor
        self.font = font
        self.backgroundColor = backgroundColor
    }
    
    func setTextWithLineHeight(text: String?, lineHeight: CGFloat) {
        if let text = text {
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight
            
            let range = NSRange(location: 0, length: text.count)
            
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style,
                .baselineOffset: (lineHeight - font.lineHeight) / 2
            ]
            
            let mutableAttrString = NSMutableAttributedString(string: text)
            
            mutableAttrString.addAttributes(attributes, range: range)

            self.attributedText = mutableAttrString
        }
    }
}
