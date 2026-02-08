//
//  UIImage+.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/9/26.
//

import UIKit

extension UIImage {
    
    func resize(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let renderedImage = renderer.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return renderedImage
    }
}
