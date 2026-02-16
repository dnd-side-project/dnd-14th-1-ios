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
    case hakgyoansimDunggeunmisoBold = "Hakgyoansim Dunggeunmiso OTF B"
    case hakgyoansimDunggeunmisoRegular = "Hakgyoansim Dunggeunmiso OTF R"
}

extension UIFont {
    static func font(_ style: FontName, ofSize size: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: style.rawValue, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        
        return customFont
    }
    
    // Display1
    @nonobjc class var display1_b: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 40)
    }
    @nonobjc class var display1_m: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 40)
    }
    @nonobjc class var display1_r: UIFont {
        return UIFont.font(.pretendardRegular, ofSize: 40)
    }
    
    // Display2
    
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
    
    // Headline2
    
    @nonobjc class var headline2_b: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 28)
    }
    @nonobjc class var headline2_m: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 28)
    }
    @nonobjc class var headline2_r: UIFont {
        return UIFont.font(.pretendardRegular, ofSize: 28)
    }
    
    // Headline3
    
    @nonobjc class var headline3_b: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 24)
    }
    @nonobjc class var headline3_m: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 24)
    }
    @nonobjc class var headline3_r: UIFont {
        return UIFont.font(.pretendardRegular, ofSize: 24)
    }
    
    // Title1
    
    @nonobjc class var title1_b: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 20)
    }
    @nonobjc class var title1_m: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 20)
    }
    @nonobjc class var title1_r: UIFont {
        return UIFont.font(.pretendardRegular, ofSize: 20)
    }
    
    // Title2
    
    @nonobjc class var title2_b: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 18)
    }
    @nonobjc class var title2_m: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 18)
    }
    @nonobjc class var title2_r: UIFont {
        return UIFont.font(.pretendardRegular, ofSize: 18)
    }
    
    // Title3
    
    @nonobjc class var title3_b: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 16)
    }
    @nonobjc class var title3_m: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 16)
    }
    @nonobjc class var title3_r: UIFont {
        return UIFont.font(.pretendardRegular, ofSize: 16)
    }
    
    // Body1
    
    @nonobjc class var body1_b: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 16)
    }
    @nonobjc class var body1_m: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 16)
    }
    @nonobjc class var body1_r: UIFont {
        return UIFont.font(.pretendardRegular, ofSize: 16)
    }
    
    // Body2
    
    @nonobjc class var body2_b: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 14)
    }
    @nonobjc class var body2_m: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 14)
    }
    @nonobjc class var body2_r: UIFont {
        return UIFont.font(.pretendardRegular, ofSize: 14)
    }
    
    // Label1
    
    @nonobjc class var label1_b: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 14)
    }
    @nonobjc class var label1_m: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 14)
    }
    @nonobjc class var label1_r: UIFont {
        return UIFont.font(.pretendardRegular, ofSize: 14)
    }
    
    // Label2
    
    @nonobjc class var label2_b: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 12)
    }
    @nonobjc class var label2_m: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 12)
    }
    @nonobjc class var label2_r: UIFont {
        return UIFont.font(.pretendardRegular, ofSize: 12)
    }
    
    @nonobjc class var hakgyoansimDunggeunmisoBold: UIFont {
        return UIFont.font(.hakgyoansimDunggeunmisoBold, ofSize: 40)
    }
    
    @nonobjc class var hakgyoansimDunggeunmisoBold_24: UIFont {
        return UIFont.font(.hakgyoansimDunggeunmisoBold, ofSize: 24)
    }
    
    @nonobjc class var hakgyoansimDunggeunmisoBold_32: UIFont {
        return UIFont.font(.hakgyoansimDunggeunmisoBold, ofSize: 32)
    }
    
    @nonobjc class var hakgyoansimDunggeunmisoRegular: UIFont {
        return UIFont.font(.hakgyoansimDunggeunmisoRegular, ofSize: 32)
    }
    
    @nonobjc class var hakgyoansimDunggeunmisoRegular_24: UIFont {
        return UIFont.font(.hakgyoansimDunggeunmisoRegular, ofSize: 24)
    }
}
