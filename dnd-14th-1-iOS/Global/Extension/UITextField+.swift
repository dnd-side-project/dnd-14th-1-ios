//
//  UITextField+.swift
//  dnd-14th-1-iOS
//
//  Created by a on 1/31/26.
//

import UIKit

extension UITextField {
    func setPlaceholder(_ placeholder: String, _ placeholderColor: UIColor) {
           attributedPlaceholder = NSAttributedString(
               string: placeholder,
               attributes: [
                   .foregroundColor: placeholderColor,
                   .font: font
               ].compactMapValues { $0 }
           )
       }
}
