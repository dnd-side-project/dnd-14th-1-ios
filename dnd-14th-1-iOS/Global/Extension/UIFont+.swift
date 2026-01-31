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
    
    // Display 1
    @nonobjc class var display1_b: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 40)
    }
    @nonobjc class var display1_m: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 40)
    }
    @nonobjc class var display1_r: UIFont {
        return UIFont.font(.pretendardRegular, ofSize: 40)
    }
    
    // Display 2
    @nonobjc class var display2_b: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 32)
    }
    @nonobjc class var display2_m: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 32)
    }
    @nonobjc class var display2_r: UIFont {
        return UIFont.font(.pretendardRegular, ofSize: 32)
    }
    
    // Headline1
    @nonobjc class var headline1_b: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 32)
    }
    @nonobjc class var headline1_m: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 32)
    }
    @nonobjc class var headline1_r: UIFont {
        return UIFont.font(.pretendardRegular, ofSize: 32)
    }
}
