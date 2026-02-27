//
//  UIView+.swift
//  dnd-14th-1-iOS
//
//  Created by a on 1/31/26.
//

import UIKit

extension UIView {

    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }

    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
