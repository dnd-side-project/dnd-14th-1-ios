//
//  UIFont+.swift
//  dnd-14th-1-iOS
//
//  Created by a on 1/31/26.
//

import UIKit

enum FontName: String {
    case pretendardBlack = "Pretendard-Black"
    case pretendardBold = "Pretendard-Bold"
    case pretendardExtraBold = "Pretendard-ExtraBold"
    case pretendardExtraLight = "Pretendard-ExtraLight"
    case pretendardLight = "Pretendard-Light"
    case pretendardMedium = "Pretendard-Medium"
    case pretendardRegular = "Pretendard-Regular"
    case pretendardSemiBold = "Pretendard-SemiBold"
    case pretendardThin = "Pretendard-Thin"
}

extension UIFont {
    static func font(_ style: FontName, ofSize size: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: style.rawValue, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        
        return customFont
    }
    
    @nonobjc class var head1: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 25)
    }
    
    @nonobjc class var subhead1: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 18)
    }
    
    @nonobjc class var subhead2: UIFont {
        return UIFont.font(.pretendardRegular, ofSize: 16)
    }
    
    @nonobjc class var subhead3: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 15)
    }
    
    @nonobjc class var subhead4: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 14)
    }
    
    @nonobjc class var subhead5: UIFont {
        return UIFont.font(.pretendardRegular, ofSize: 14)
    }
    
    @nonobjc class var info12: UIFont {
        return UIFont.font(.pretendardRegular, ofSize: 12)
    }
}
