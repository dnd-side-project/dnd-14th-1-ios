//
//  UIStackView+.swift
//  dnd-14th-1-iOS
//
//  Created by a on 1/31/26.
//

import UIKit

extension UIStackView {

    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }

}
